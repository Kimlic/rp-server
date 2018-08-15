defmodule RpCore.Server.MediaServer do
  @moduledoc false

  use GenServer

  alias RpCore.Server.MediaRegistry
  alias RpCore.Model.{Document, Photo}
  alias RpCore.Media.Upload

  @not_verified "0x0000000000000000000000000000000000000000000000000000000000000000"

  ##### Public #####

  def start_link(_args_init, args) do
    session_tag = args[:session_tag]
    GenServer.start_link(__MODULE__, args, name: via_tuple(session_tag))
  end

  def push_photo(session_tag, media_type, file, hash) do
    via_tuple(session_tag)
    |> GenServer.call({:push_photo, media_type: media_type, file: file, hash: hash}, 60_000)
  end

  def get_state(session_tag) do
    via_tuple(session_tag)
    |> GenServer.call(:get_state)
  end

  def get_document(session_tag) do
    via_tuple(session_tag)
    |> GenServer.call(:get_document)
  end

  def get_session_id(session_tag) do
    via_tuple(session_tag)
    |> GenServer.call(:get_session_id)
  end

  def get_verification_status(session_tag) do
    via_tuple(session_tag)
    |> GenServer.call(:get_verification_status)
  end

  ##### Private #####

  def whereis(name: name) do
    MediaRegistry.whereis_name({:media_server, name})
  end

  @impl true
  def init(user_address: user_address, doc_type_str: doc_type_str, session_tag: session_tag, first_name: first_name, last_name: last_name, device: device, udid: udid, country: country) do
    # vendors = RpAttestation.vendors()
    # IO.inspect "VENDORS: #{inspect vendors}"
    vendors = []

    with {:ok, session_id} <- start_verification(user_address, doc_type_str, session_tag, first_name, last_name, device, udid),
    {:ok, %Document{} = document} <- Upload.create_document(user_address, doc_type_str, session_tag, first_name, last_name, country) do
      check_verification_status()

      state = %{
        document: document, 
        session_id: session_id, 
        photos: [], 
        vendors: vendors,
        verified: false
      }

      {:ok, state}
    else
      {:error, method, tx} -> {:stop, "Unable to start media server: #{inspect method}, #{inspect tx}"}
      {:error, reason} -> {:stop, "Unable to start media server: #{inspect reason}"}
    end    
  end
  def init(args), do: {:error, args}

  @impl true
  def handle_call(:get_state, _from, state), do: {:reply, {:ok, state}, state}
  def handle_call(:get_session_id, _from, state), do: {:reply, {:ok, state[:session_id]}, state}
  def handle_call(:get_document, _from, state), do: {:reply, {:ok, state[:document]}, state}
  def handle_call({:push_photo, media_type: media_type, file: file, hash: hash}, _from, %{photos: photos, document: document, session_id: session_id} = state) do
    with {:ok, photo} <- upload_photo(document.id, media_type, file, hash, document.country, session_id) do
      new_photos = photos ++ [photo]
      new_state = %{state | photos: new_photos}

      {:reply, {:ok, :created}, new_state}
    else
      {:error, reason} -> {:reply, {:error, reason}, state}
    end
  end
  def handle_call(message, _from, state), do: {:reply, {:error, message}, state}

  @impl true
  def handle_info({:check_verification, attempt}, %{document: document, verified: false} = state) do
    if attempt < 1 do
      Document.delete!(document.session_tag)
      Process.exit(self(), :normal)
    end

    with {:ok, config} <- RpKimcore.config,
    {:ok, provisioning_contract_factory_address} <- config.context_contract |> RpQuorum.get_provisioning_contract_factory,
    {:ok, provisioning_contract_address} <- provisioning_contract_factory_address |> RpQuorum.get_provisioning_contract(document.session_tag),
    {:ok, @not_verified} <- provisioning_contract_address |> RpQuorum.is_verification_finished do
      check_verification_status(attempt - 1)
      {:noreply, state}
    else
      {:error, _reason} -> {:noreply, state}
      _answer -> {:noreply, %{state | verified: true}}
    end

    {:noreply, state}
  end
  def handle_info(_, state), do: {:noreply, state}

  defp via_tuple(name), do: {:via, MediaRegistry, {:media_server, name}}

  @spec start_verification(binary, binary, UUID, binary, binary, binary, binary) :: {:ok, binary} | {:error, binary}
  defp start_verification(user_address, doc_type, session_tag, first_name, last_name, device, udid) do
    veriff_doc = document_type_veriff(doc_type)
  
    with {:ok, config} <- RpKimcore.config,
    {:ok, provisioning_contract_factory_address} <- config.context_contract |> RpQuorum.get_provisioning_contract_factory,
    {:ok, _method, _tx_hash} <- provisioning_contract_factory_address |> RpQuorum.create_provisioning_contract(user_address, doc_type, session_tag),
    {:ok, verification_contract_factory_address} <- config.context_contract |> RpQuorum.get_verification_contract_factory,
    {:ok, _method, _tx_hash} <- verification_contract_factory_address |> RpQuorum.create_base_verification_contract(user_address, Enum.fetch!(config.attestation_parties, 0).address, doc_type, session_tag),
    {:ok, verification_contract_address} <- verification_contract_factory_address |> RpQuorum.get_verification_contract(session_tag),
    {:ok, %{"data" => %{"session_id" => session_id}}} <- RpAttestation.session_create(first_name, last_name, veriff_doc, verification_contract_address, device, udid) do
      {:ok, session_id}
    else
      err -> err
    end
  end

  defp upload_photo(document_id, media_type, file, hash, country, session_id) do
    media_type_str = photo_type(media_type)

    with {:error, :not_found} <- Photo.find_one_by(document_id, media_type_str, hash),
    {:ok, %{"data" => %{"status" => "ok"}}} <- RpAttestation.photo_upload(session_id, country, media_type_str, file),
    {:ok, photo} = Upload.create_photo(document_id, media_type_str, file, hash) do
      {:ok, photo}   
    else
      {:ok, photo} -> {:ok, photo}
      {:ok, %{"error" => %{"invalid" => [%{"rules" => [%{"description" => reason}]}]}}} -> {:error, reason}
      {:error, reason} -> {:error, reason}
    end
  end

  defp check_verification_status(attempt \\ 5), do: Process.send_after(self(), {:check_verification, attempt}, 5 * 60 * 1_000)

  defp photo_type(type) do
    case type do
      :face -> "face"
      :back -> "document-back"
      :front -> "document-front"
      _ -> {:error, "Unknown media type"}
    end
  end

  defp document_type_veriff(type) do
    case type do
      "documents.id_card" -> "ID_CARD"
      "documents.passport" -> "PASSPORT"
      "documents.driver_license" -> "DRIVERS_LICENSE"
      "documents.residence_permit_card" -> "RESIDENCE_PERMIT_CARD"
      _ -> {:error, "Unknown veriff document"}
    end
  end
end