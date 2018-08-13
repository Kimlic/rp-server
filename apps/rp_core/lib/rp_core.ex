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

  @spec store_media(binary, atom, atom, media_type) :: {:ok, binary} | {:error, binary}
  def store_media(user_address, :id_card, :veriff_me, [{media_type, file}]) do
    # RpQuorum.create_account

    hash = hash_file(file)
    media_type_str = photo_type(media_type)
    doc_type_str = @doc_veriff_id_card
    session_tag = UUID.uuid1

    with {:error, :not_found} <- Photo.find_one_by(hash),
    {:error, :not_found} <- Document.find_one_by(user_address, doc_type_str) do
      IO.inspect "NEW DOCUMENT"
      {:ok, :created} = start_provisioning(user_address, doc_type_str, session_tag)
      IO.inspect "PROVISIONING CONTRACT CREATED"
      {:ok, session_tag} = start_verification(user_address, doc_type_str, session_tag)
      IO.inspect "START VERIFICATION: #{inspect session_tag}"
      {:ok, document} = Upload.create_document(user_address, doc_type_str, session_tag)
      IO.inspect "CREATE DOCUMENT: #{inspect document}"
      {:ok, pid} = MediaSupervisor.start_child(document: document)
      IO.inspect "START SERVER: #{inspect pid}"
      {:ok, url} = document_found(document, media_type_str, file, hash)
      IO.inspect "URL: #{inspect url}"
      res = create_verification_session(session_tag)
      IO.inspect "RES: #{inspect res}"

      {:ok, url}
    else
      {:error, method, %{"status" => "0x0"} = tx_receipt} -> {:error, "TX failed on #{inspect method}: #{inspect tx_receipt}"}
      {:error, method, reason} -> {:error, "TX failed on #{inspect method}: #{inspect reason}"}
      {:error, reason} -> {:error, reason}
      
      {:ok, document} -> 
        IO.inspect "DOCUMENT EXISTS"
        {:ok, url} = document_found(document, media_type_str, file, hash)

        {:ok, url}

      err -> IO.inspect "ERR: #{inspect err}"
    end
  end

  def document_found(document, media_type_str, file, hash) do
    with {:error, :not_found} <- Photo.find_one_by(document.id, media_type_str, hash),
    {:ok, photo} = Upload.create_photo(document.id, media_type_str, file, hash) do
      MediaServer.push_photo(document.session_tag, photo)

      {:ok, Photo.url(photo)}
    else
      {:ok, photo} -> {:ok, Photo.url(photo)}
      {:error, reason} -> {:error, reason}
    end
  end

  def start_provisioning(user_address, doc_type, session_tag) do
    with {:ok, config} <- RpKimcore.config,
    {:ok, provisioning_contract_factory_address} <- config.context_contract |> RpQuorum.get_provisioning_contract_factory,
    {:ok, _method, _tx_hash} <- provisioning_contract_factory_address |> RpQuorum.create_provisioning_contract(user_address, doc_type, session_tag) do
      {:ok, :created}
    else
      err -> err
    end
  end

  # def get_verification_status(user_address, doc_type, session_tag) do
  #   with {:ok, config} <- RpKimcore.config,
  #   {:ok, provisioning_contract_factory_address} <- config.context_contract |> RpQuorum.get_provisioning_contract_factory,
  #   {:ok, _method, _tx_hash} <- provisioning_contract_factory_address |> RpQuorum.create_provisioning_contract(user_address, doc_type, session_tag),
  #   {:ok, provisioning_contract_address} <- provisioning_contract_factory_address |> RpQuorum.get_provisioning_contract(session_tag),
  #   {:ok, @not_verified} <- provisioning_contract_address |> RpQuorum.is_verification_finished do
  #     {:ok, :not_verified}
  #   else
  #     err -> err
  #   end
  # end

  ##### Private #####

  @spec start_verification(binary, binary, UUID) :: {:ok, binary} | {:error, binary}
  defp start_verification(user_address, doc_type, session_tag) do
    with {:ok, config} <- RpKimcore.config,
    {:ok, verification_contract_factory_address} <- config.context_contract |> RpQuorum.get_verification_contract_factory,
    {:ok, _method, _tx_hash} <- verification_contract_factory_address |> RpQuorum.create_base_verification_contract(user_address, Enum.fetch!(config.attestation_parties, 0).address, doc_type, session_tag) do
      {:ok, session_tag}
    else
      err -> err
    end
  end

  defp create_verification_session(session_tag) do
    with {:ok, config} <- RpKimcore.config,
    {:ok, verification_contract_factory_address} <- config.context_contract |> RpQuorum.get_verification_contract_factory,
    {:ok, verification_contract_address} <- verification_contract_factory_address |> RpQuorum.get_verification_contract(session_tag) do
      IO.inspect "VERIF CONTRACT ADDR: #{verification_contract_address}"
      RpAttestation.session_create("John", "Doe", "ID_CARD", verification_contract_address, "android", "123456")
    else
      err -> IO.inspect err
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
