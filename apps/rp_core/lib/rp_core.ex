defmodule RpCore do
  @moduledoc false

  alias RpCore.Media.Upload
  alias RpCore.Model.Photo

  @not_verified "0x0000000000000000000000000000000000000000000000000000000000000000"
  @doc_veriff_id_card "documents.id_card"

  @type media_type :: {:face, String.t} | {:front, String.t} | {:back, String.t}

  ##### Public #####

  @spec store_media(binary, atom, atom, media_type) :: {:ok, binary, binary} | {:error, binary}
  def store_media(user_address, :id_card, :veriff_me, [{media_type, file}]) do
    hash = hash_file(file)
    
    case Photo.find_one_by(hash) do
      {:ok, photo} -> {:ok, photo |> Photo.url,  photo.document.session_tag}
      {:error, :not_found} -> start_upload(user_address, @doc_veriff_id_card, Atom.to_string(media_type), file, hash, UUID.uuid1)
    end
  end
  def store_media(user_address, doc_type, attestator, media_type) do
    {:error, "Unknown media #{doc_type}, #{inspect media_type} sent by #{user_address} to attestator #{inspect attestator}"}
  end

  ##### Private #####

  defp start_upload(user_address, doc_type, media_type, file, file_hash, session_tag) do
    with {:ok, session_tag} <- start_verification(user_address, doc_type, session_tag),
    {:ok, url} <- Upload.handle(user_address, doc_type, media_type, file, file_hash, session_tag) do
      {:ok, url, session_tag}
    else
      {:error, reason} -> {:error, reason}
      err -> {:error, "Unknown error in RpCore.store_media: #{err}"}
    end
  end

  @spec start_verification(binary, binary, UUID) :: {:ok, binary} | {:error, binary}
  defp start_verification(user_address, doc_type, session_tag) do
    with {:ok, config} <- RpKimcore.config,
    {:ok, provisioning_contract_factory_address} <- config.context_contract |> RpQuorum.get_provisioning_contract_factory,
    {:ok, _method, _tx_hash} <- provisioning_contract_factory_address |> RpQuorum.create_provisioning_contract(user_address, doc_type, session_tag),
    {:ok, provisioning_contract_address} <- provisioning_contract_factory_address |> RpQuorum.get_provisioning_contract(session_tag),
    {:ok, @not_verified} <- provisioning_contract_address |> RpQuorum.is_verification_finished,
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
