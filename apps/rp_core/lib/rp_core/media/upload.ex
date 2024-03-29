defmodule RpCore.Media.Upload do
  @moduledoc false
 
  alias RpCore.Uploader.File
  alias RpCore.Media.Image
  alias RpCore.Model.{Document, Photo, LogosCompany, Attestator}
  alias RpCore.Mapper

  @type media_type :: :face | :front | :back
  
  ##### Public #####

  @spec create_document(binary, binary, binary, binary, binary, binary) :: {:ok, Document} | {:error, binary}
  def create_document(user_address, doc_type, session_tag, first_name, last_name, country) do
    with {:ok, %Attestator{} = veriff} <- Attestator.veriff(),
    {:ok, %Document{} = document} <- Document.create(user_address, doc_type, session_tag, first_name, last_name, country, veriff) do
      {:ok, document}
    else
      {:error, changeset} -> pretty_errors(changeset)
    end
  end

  @spec create_photo(media_type, UUID, binary, binary) :: {:ok, Photo} | {:error, :not_found | Ecto.Changeset.t}
  def create_photo(media_type, document_id, file, file_hash) do
    with media_type_veriff <- Mapper.Veriff.photo_atom_to_veriff(media_type),
    {:error, :not_found} <- Photo.find_one_by(document_id, media_type_veriff, file_hash),
    {:ok, filename} <- store_image(file),
    {:ok, url} <- File.file_url(filename),
    {:ok, %Photo{} = photo} <- Photo.create_photo(url, file_hash, media_type_veriff, document_id) do
      {:ok, photo}
    else
      {:ok, %Photo{} = photo} -> {:ok, photo}
      {:error, :not_found} -> {:error, :not_found}
      {:error, %Ecto.Changeset{} = changeset} -> pretty_errors(changeset)
    end
  end

  @spec replace_logo(UUID, binary) :: {:ok, LogosCompany} | {:error, :not_found} | {:error, binary}
  def replace_logo(company_id, file) do
    with _ <- LogosCompany.delete_all(),
    {:ok, logo} <- LogosCompany.create_logo(file, company_id) do
      {:ok, logo}
    else
      {:error, :not_found} -> {:error, :not_found}
      {:error, changeset} -> pretty_errors(changeset)
    end
  end

  ##### Private #####

  @spec store_image(binary) :: {:ok, binary}
  defp store_image(file) do
    Image.base64_to_binary(file)
    |> create_filename
    |> File.store
  end

  @spec create_filename(binary) :: map
  defp create_filename(binary) do
    name = Image.image_extension(binary)
    |> Image.unique_filename()
    |> to_charlist

    %{filename: name, binary: binary}
  end

  @spec pretty_errors(Ecto.Changeset.t) :: {:error, binary}
  defp pretty_errors(changeset) do
    errors = for {_key, {message, _}} <- changeset.errors, do: "#{message}"
    {:error, errors}
  end
end
