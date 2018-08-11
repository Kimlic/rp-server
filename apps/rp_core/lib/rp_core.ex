defmodule RpCore do
  @moduledoc false

  alias RpCore.Media.Upload
  alias RpCore.Model.{Document, Photo}

  @not_verified "0x0000000000000000000000000000000000000000000000000000000000000000"
  @doc_veriff_id_card "documents.id_card"

  @type media_type :: {:face, String.t} | {:front, String.t} | {:back, String.t}

  ##### Public #####

  @spec store_media(binary, atom, atom, media_type) :: {:ok, binary} | {:error, binary}
  def store_media(user_address, :id_card, :veriff_me, [{media_type, file}]) do
    hash = hash_file(file)
    media_type_str = Atom.to_string(media_type)

    case Photo.find_one_by(user_address, @doc_veriff_id_card, media_type_str, hash) do
      {:error, :not_found} -> start_upload(user_address, @doc_veriff_id_card, media_type_str, file, hash, UUID.uuid1)
      {:ok, photo} -> {:ok, Photo.url(photo)}
    end
  end
  def store_media(user_address, doc_type, attestator, media_type) do
    {:error, "Unknown media #{doc_type}, #{inspect media_type} sent by #{user_address} to attestator #{inspect attestator}"}
  end

  def get_verification_status(user_address, doc_type, session_tag, config) do
    with {:ok, provisioning_contract_factory_address} <- config.context_contract |> RpQuorum.get_provisioning_contract_factory,
    {:ok, _method, _tx_hash} <- provisioning_contract_factory_address |> RpQuorum.create_provisioning_contract(user_address, doc_type, session_tag),
    {:ok, provisioning_contract_address} <- provisioning_contract_factory_address |> RpQuorum.get_provisioning_contract(session_tag),
    {:ok, @not_verified} <- provisioning_contract_address |> RpQuorum.is_verification_finished do
      {:ok, :not_verified}
    else
      err -> err
    end
  end

  ##### Private #####

  defp start_upload(user_address, doc_type, media_type, file, file_hash, session_tag) do
    case Document.find_by(user_address, doc_type) do
      {:error, :not_found} ->
        with {:ok, session_tag} <- start_verification(user_address, doc_type, session_tag),
        {:ok, url} <- Upload.create_document(user_address, doc_type, media_type, file, file_hash, session_tag) do
          {:ok, url}
        else
          {:error, reason} -> {:error, reason}
          err -> {:error, "Unknown error in RpCore.store_media: #{err}"}
        end

      {:ok, document} -> 
        with {:ok, url} <- Upload.proceed_document(document, media_type, file, file_hash) do
          {:ok, url}
        else
          {:error, reason} -> {:error, reason}
          err -> {:error, "Unknown error in RpCore.store_media: #{err}"}
        end

      err -> IO.inspect "ERR: #{inspect err}"
    end
  end

  @spec start_verification(binary, binary, UUID) :: {:ok, binary} | {:error, binary}
  defp start_verification(user_address, doc_type, session_tag) do
    with {:ok, config} <- RpKimcore.config,
    {:ok, :not_verified} <- get_verification_status(user_address, doc_type, session_tag, config),
    {:ok, verification_contract_factory_address} <- config.context_contract |> RpQuorum.get_verification_contract_factory,
    {:ok, _method, _tx_hash} <- verification_contract_factory_address |> RpQuorum.create_base_verification_contract(user_address, Enum.fetch!(config.attestation_parties, 0).address, doc_type, session_tag) do
      {:ok, session_tag}
    else
      {:error, method, %{"status" => "0x0"} = tx_receipt} -> {:error, "TX failed on #{inspect method}: #{inspect tx_receipt}"}
      {:error, method, reason} -> {:error, "TX failed on #{inspect method}: #{inspect reason}"}
      {:error, reason} -> {:error, reason}
      err -> IO.inspect "ERR: #{inspect err}"
    end
  end

  defp hash_file(file), do: :crypto.hash(:sha256, file) |> Base.encode16
end
