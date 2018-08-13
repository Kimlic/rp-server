defmodule RpCore do
  @moduledoc false

  alias RpCore.Media.Upload
  alias RpCore.Model.{Document, Photo}
  alias RpCore.Server.MediaSupervisor
  alias RpCore.Server.MediaServer

  @not_verified "0x0000000000000000000000000000000000000000000000000000000000000000"
  @doc_veriff_id_card "documents.id_card"

  @type media_type :: {:face, String.t} | {:front, String.t} | {:back, String.t}

  ##### Public #####

  @spec store_media(binary, atom, atom, binary, binary, binary, binary, binary, media_type) :: {:ok, binary} | {:error, binary}
  def store_media(user_address, :id_card, :veriff_me, first_name, last_name, country, device, udid, [{media_type, file}]) do
    # RpQuorum.create_account

    hash = hash_file(file)
    doc_type_str = @doc_veriff_id_card

    with {:error, :not_found} <- find_document(user_address, doc_type_str, hash) do
      session_tag = UUID.uuid1
      {:ok, session_id} = start_verification(user_address, doc_type_str, session_tag, first_name, last_name, device, udid)
      {:ok, %Document{} = document} = Upload.create_document(user_address, doc_type_str, session_tag, first_name, last_name, country)
      {:ok, _pid} = MediaSupervisor.start_child(document: document, session_id: session_id)
      upload_photo(document, media_type, file, hash, country)
    else
      {:error, method, %{"status" => "0x0"} = tx_receipt} -> {:error, "TX failed on #{inspect method}: #{inspect tx_receipt}"}
      {:error, method, reason} -> {:error, "TX failed on #{inspect method}: #{inspect reason}"}
      {:error, reason} -> {:error, reason}
      {:ok, %Photo{} = photo} -> {:ok, Photo.url(photo)}
      {:ok, %Document{} = document} -> upload_photo(document, media_type, file, hash, country)
      err -> IO.inspect "ERR: #{inspect err}"
    end
  end

  def get_verification_status(session_tag) do
    with {:ok, config} <- RpKimcore.config,
    {:ok, provisioning_contract_factory_address} <- config.context_contract |> RpQuorum.get_provisioning_contract_factory,
    {:ok, provisioning_contract_address} <- provisioning_contract_factory_address |> RpQuorum.get_provisioning_contract(session_tag),
    {:ok, @not_verified} <- provisioning_contract_address |> RpQuorum.is_verification_finished do
      {:ok, :not_verified}
    else
      err -> err
    end
  end

  ##### Private #####

  def find_document(user_address, doc_type_str, hash) do
    with {:error, :not_found} <- Photo.find_one_by(hash),
    {:error, :not_found} <- Document.find_one_by(user_address, doc_type_str) do
      {:error, :not_found}
    else
      {:ok, %Photo{} = photo} -> {:ok, photo}
      {:ok, %Document{} = document} -> {:ok, document}
    end
  end

  @spec start_verification(binary, binary, UUID, binary, binary, binary, binary) :: {:ok, binary} | {:error, binary}
  defp start_verification(user_address, doc_type, session_tag, first_name, last_name, device, udid) do
    with {:ok, config} <- RpKimcore.config,
    {:ok, provisioning_contract_factory_address} <- config.context_contract |> RpQuorum.get_provisioning_contract_factory,
    {:ok, _method, _tx_hash} <- provisioning_contract_factory_address |> RpQuorum.create_provisioning_contract(user_address, doc_type, session_tag),
    {:ok, verification_contract_factory_address} <- config.context_contract |> RpQuorum.get_verification_contract_factory,
    {:ok, _method, _tx_hash} <- verification_contract_factory_address |> RpQuorum.create_base_verification_contract(user_address, Enum.fetch!(config.attestation_parties, 0).address, doc_type, session_tag),
    {:ok, verification_contract_address} <- verification_contract_factory_address |> RpQuorum.get_verification_contract(session_tag),
    {:ok, %{"data" => %{"session_id" => session_id}}} <- RpAttestation.session_create(first_name, last_name, "ID_CARD", verification_contract_address, device, udid) do
      {:ok, session_id}
    else
      err -> err
    end
  end

  defp upload_photo(document, media_type, file, hash, country) do
    media_type_str = photo_type(media_type)

    with {:error, :not_found} <- Photo.find_one_by(document.id, media_type_str, hash),
    {:ok, photo} = Upload.create_photo(document.id, media_type_str, file, hash) do
      MediaServer.push_photo(document.session_tag, photo)
      {:ok, session_id} = MediaServer.get_session_id(document.session_tag)
      {:ok, %{"data" => %{"status" => "ok"}}} = RpAttestation.photo_upload(session_id, country, media_type_str, file)
      {:ok, Photo.url(photo)}
    else
      {:ok, photo} -> {:ok, Photo.url(photo)}
      {:error, reason} -> {:error, reason}
    end
  end

  defp hash_file(file), do: :crypto.hash(:sha256, file) |> Base.encode16

  defp photo_type(type) do
    case type do
      :face -> "face"
      :back -> "document-back"
      :front -> "document-front"
      _ -> {:error, "Unknown media type"}
    end
  end
end
