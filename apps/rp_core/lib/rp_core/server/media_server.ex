defmodule RpCore.Server.MediaServer do
  @moduledoc false

  defstruct [
    document: nil, 
    photos: [], 
    vendors: [], 
    session_id: nil, 
    verification_info: nil, 
    contracts: %{}
  ]

  use GenServer

  alias __MODULE__
  alias RpCore.Server.MediaRegistry
  alias RpCore.Model.Document
  alias RpCore.Media.Upload
  alias RpCore.Mapper

  @max_check_polls 12 * 24
  # @poll_time 5 * 60 * 1_000
  @poll_time 60 * 1_000
  @timeout 180_000

  ##### Public #####

  def start_link(_args_init, args) do
    name = args[:session_tag] |> via
    GenServer.start_link(__MODULE__, args, name: name)
  end

  @spec push_photo(binary, binary, binary, binary) :: {:ok, :created} | {:error, binary}
  def push_photo(session_tag, media_type, file, hash) do
    args = [
      media_type: media_type, 
      file: file, 
      hash: hash
    ]

    via(session_tag)
    |> GenServer.call({:push_photo, args}, @timeout)
  end

  @spec verification_info(binary) :: {:ok, map} | {:ok, nil}
  def verification_info(session_tag) do
    via(session_tag)
    |> GenServer.call(:verification_info)
  end

  ##### Callbacks #####

  def whereis(name: name), do: MediaRegistry.whereis_name({:media_server, name})

  def consumption_first() do
  end
  def consumption() do
  end

  @impl true
  def init(user_address: user_address, doc_type_str: doc_type_str, session_tag: session_tag, first_name: first_name, last_name: last_name, device: device, udid: udid, country: country) do
    {:ok, config} = RpKimcore.config()

    config.context_contract
    |> RpQuorum.create_provisioning(user_address, doc_type_str, session_tag)
    |> RpQuorum.verification_decision
    |> case do
      {:ok, :verified, _} ->
        {:ok, %Document{} = document} = Upload.create_document(user_address, doc_type_str, session_tag, first_name, last_name, country)
        Document.assign_verification(document, nil)
        
        state = %MediaServer{
          document: document,
        }
        {:ok, state}

      {:ok, :unverified, provisioning_contract} ->
        ap_address = RpKimcore.veriff()
        {:ok, verification_contract} = RpQuorum.create_verification(config.context_contract, user_address, ap_address, doc_type_str, session_tag)
        veriff_doc = Mapper.Veriff.document_quorum_to_veriff(doc_type_str)

        case RpAttestation.session_create(first_name, last_name, veriff_doc, verification_contract, device, udid) do
          {:error, reason} -> {:stop, reason}
          {:ok, session_id} ->
            with {:ok, %Document{} = document} <- Upload.create_document(user_address, doc_type_str, session_tag, first_name, last_name, country) do
              check_verification_attempt(@max_check_polls)

              state = %MediaServer{
                document: document,
                session_id: session_id,
                contracts: %{
                  provisioning_contract: provisioning_contract,
                  verification_contract: verification_contract
                }
              }
              {:ok, state}
            else
              {:error, reason} -> {:stop, reason}
            end
        end
    end
  end

  @impl true
  def handle_call(:verification_info, _from, state), do: {:reply, {:ok, state[:verification_info]}, state}
  def handle_call({:push_photo, media_type: media_type, file: file, hash: hash}, _from, %{photos: photos, document: document, session_id: session_id, verification_info: verification_info} = state) do
    with {:ok, photo} <- Upload.create_photo(media_type, document.id, file, hash) do
      if is_nil(verification_info) do
        media_type
        |> Mapper.Veriff.photo_atom_to_veriff
        |> RpAttestation.photo_upload(session_id, document.country, file)
      end

      new_photos = photos ++ [photo]
      new_state = %{state | photos: new_photos}

      {:reply, {:ok, :created}, new_state}
    else
      {:error, reason} -> {:reply, {:error, reason}, state}
    end
  end
  def handle_call(message, _from, state), do: {:reply, {:error, message}, state}

  @impl true
  def handle_info({:check_verification_attempt, attempt}, %{document: document, session_id: session_id, contracts: %{provisioning_contract: provisioning_contract}} = state) do
    if attempt < 1 do
      stop_server(provisioning_contract)
    else
      provisioning_contract
      |> RpQuorum.verification_decision
      |> case do
        {:ok, :verified, _} -> 
          {:ok, info} = RpAttestation.verification_info(session_id)
          {:ok, result_doc} = Document.assign_verification(document, info)

          case result_doc.status do
            "approved" -> {:stop, :shutdown, nil}
            _ -> {:stop, {:shutdown, result_doc.reason}, nil}
          end

        {:ok, :unverified, _} -> 
          check_verification_attempt(attempt - 1)
          {:noreply, state}
      end
    end
  end

  ##### Private #####

  @spec via(binary) :: tuple
  defp via(name), do: {:via, MediaRegistry, {:media_server, name}}

  @spec check_verification_attempt(number()) :: reference()
  defp check_verification_attempt(attempt) do
    self() 
    |> Process.send_after({:check_verification_attempt, attempt}, @poll_time)
  end

  defp stop_server(provisioning_contract) do
    RpQuorum.revoke_provisioning(provisioning_contract)
    stop()
  end

  defp stop, do: self() |> Process.exit(:normal)
end