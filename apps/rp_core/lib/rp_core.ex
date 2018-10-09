defmodule RpCore do
  @moduledoc false

  alias RpCore.Model.{Document, Photo, Company, LogosCompany, Attestator}
  alias RpCore.Media.Upload
  alias RpCore.Server.MediaSupervisor
  alias RpCore.Server.MediaServer

  @type media_type :: {:face, String.t} | {:front, String.t} | {:back, String.t}

  ##### Mobile #####

  @spec store_media(binary, atom, atom, binary, binary, binary, binary, binary, media_type) :: {:ok, binary} | {:ok, :created} | {:error, binary}
  def store_media(user_address, doc_type, _attestator, first_name, last_name, country, device, udid, [{media_type, file}]) do
    hash = hash_file(file)
    doc_type_str = document_type(doc_type)

    with {:error, :not_found} <- find_document(user_address, doc_type_str, hash) do
      session_tag = UUID.uuid1
      params = [user_address: user_address, doc_type_str: doc_type_str, session_tag: session_tag, first_name: first_name, last_name: last_name, device: device, udid: udid, country: country]
      case MediaSupervisor.start_child(params) do
        {:ok, _pid} -> MediaServer.push_photo(session_tag, media_type, file, hash)
        {:error, reason} -> {:error, reason}
      end
    else
      {:error, method, %{"status" => "0x0"} = tx_receipt} -> {:error, "TX failed on #{inspect method}: #{inspect tx_receipt}"}
      {:error, method, reason} -> {:error, "TX failed on #{inspect method}: #{inspect reason}"}
      {:error, reason} -> {:error, reason}
      {:ok, %Photo{}} -> {:ok, :created}
      {:ok, %Document{} = document} -> MediaServer.push_photo(document.session_tag, media_type, file, hash)
      {:error, reason} -> {:error, reason}
    end
  end

  @spec get_verification_info(UUID) :: map
  def get_verification_info(session_tag), do: MediaServer.verification_info(session_tag)

  ##### Dashboard #####

  @spec documents() :: {:ok, list(Document.t())}
  def documents, do: Document.all()

  @spec document_by_id(binary) :: {:ok, Document.t()} | {:error, :not_found}
  def document_by_id(id), do: Document.get_by_id(id)

  @spec count_documents() :: {:ok, map}
  def count_documents, do: Document.count_documents()

  @spec documents_verified(binary) :: list(Document.t())
  def documents_verified(user_address), do: Document.get_verified(user_address)

  @spec company() :: Company.t()
  def company, do: Company.company()

  @spec company_details() :: Company.t()
  def company_details, do: Company.company_details()

  @spec company_update(UUID, map) :: {:ok, Company.t()} | {:error, Changeset.t()}
  def company_update(id, params), do: Company.update(id, params)

  @spec logo_url() :: binary
  def logo_url, do: LogosCompany.logo_url()

  @spec logo_update(UUID, binary) :: {:ok, binary}
  def logo_update(company_id, file) do
    {:ok, %LogosCompany{} = logo} = Upload.replace_logo(company_id, file)
    {:ok, LogosCompany.url(logo)}
  end

  @spec attestators() :: list(Attestator.t())
  def attestators, do: Attestator.attestators()

  ##### Private #####

  @spec find_document(binary, binary, binary) :: {:ok, Photo} | {:ok, Document} | {:error, :not_found}
  def find_document(user_address, doc_type_str, hash) do
    with {:error, :not_found} <- Photo.find_one_by(hash),
    {:error, :not_found} <- Document.find_one_by(user_address, doc_type_str) do
      {:error, :not_found}
    else
      {:ok, %Photo{} = photo} -> {:ok, photo}
      {:ok, %Document{} = document} -> {:ok, document}
    end
  end

  @spec hash_file(binary) :: binary
  defp hash_file(file), do: :crypto.hash(:sha256, file) |> Base.encode16

  @spec document_type(atom) :: binary
  defp document_type(type) do
    case type do
      :id_card -> "documents.id_card"
      :passport -> "documents.passport"
      :drivers_license -> "documents.driver_license"
      :residence_permit_card -> "documents.residence_permit_card"
      _ -> {:error, "Unknown blockchain document"}
    end
  end
end
