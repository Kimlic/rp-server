defmodule RpCore.Media.Upload do
  @moduledoc false

  alias RpCore.Repo
  alias RpCore.Uploader.File
  alias RpCore.Media.Image
  alias RpCore.Model.{Document, Photo, LogosCompany, Attestator}
  
  ##### Public #####

  @spec create_document(binary, binary, binary, binary, binary, binary) :: {:ok, binary} | {:error, binary}
  def create_document(user_address, doc_type, session_tag, first_name, last_name, country) do
    with {:ok, veriff} <- Attestator.veriff(),
    {:ok, document} <- Document.create(user_address, doc_type, session_tag, first_name, last_name, country, veriff.id) do
      {:ok, document}
    else
      {:error, changeset} -> pretty_errors(changeset)
    end
  end

  @spec create_photo(binary, binary, binary, binary) :: {:ok, Photo.t()} | {:error, :not_found} | {:error, Ecto.Changeset.t()}
  def create_photo(document_id, media_type, file, file_hash) do
    with {:error, :not_found} <- Photo.find_one_by(document_id, media_type, file_hash),
    {:ok, filename} <- store_image(file),
    {:ok, url} <- File.file_url(filename),
    {:ok, photo} <- Photo.create_photo(url, file_hash, media_type, document_id) do
      {:ok, photo}
    else
      {:ok, %Photo{} = photo} -> {:ok, photo}
      {:error, :not_found} -> {:error, "No photo uploaded"}
      {:error, changeset} -> pretty_errors(changeset)
    end
  end

  def replace_logo(company_id, file) do
    with _ <- LogosCompany.delete_all(),
    {:ok, logo} <- LogosCompany.create_logo(file, company_id) do
      {:ok, logo}
    else
      {:error, :not_found} -> {:error, "No logo uploaded"}
      {:error, changeset} -> pretty_errors(changeset)
    end
  end

  ##### Private #####

  defp store_image(file) do
    Image.base64_to_binary(file)
    |> create_filename
    |> File.store
  end

  defp create_filename(binary) do
    try do
      name = binary
      |> Image.image_extension()
      |> Image.unique_filename()
      |> to_charlist

      %{filename: name, binary: binary}
    rescue
      e in RuntimeException -> IO.puts "Exception: #{inspect e}"
    end
  end

  defp pretty_errors(changeset) do
    errors = for {_key, {message, _}} <- changeset.errors, do: "#{message}"
    {:error, errors}
  end
end
