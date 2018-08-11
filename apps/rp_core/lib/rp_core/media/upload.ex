defmodule RpCore.Media.Upload do
  @moduledoc false

  alias RpCore.Repo
  alias RpCore.Uploader.File
  alias RpCore.Model.{Document, Photo}
  
  ##### Public #####

  @spec handle(binary, binary, binary, binary, binary, binary) :: {:ok, binary} | {:error, binary}
  def handle(user_address, doc_type, media_type, file, file_hash, session_tag) do
    with {:ok, document} <- insert_doc(user_address, doc_type, session_tag),
    {:ok, filename} <- store_image(file),
    {:ok, url} <- file_url(filename),
    {:ok, photo} <- insert_photo(url, file_hash, media_type, document.id),
    {:ok, url} <- url_from_photo(photo) do
      {:ok, url}
    else
      {:error, :not_found} -> {:error, "No photo uploaded"}
      {:error, changeset} -> pretty_errors(changeset)
      err -> IO.inspect "ERROR: #{err}"
    end
  end

  ##### Private #####

  # @spec insert_doc(binary, binary, binary) :: {:ok, } || {:error, }
  defp insert_doc(user_address, doc_type, session_tag) do
    params = %{
      user_address: user_address,
      session_tag: session_tag,
      type: doc_type
    }

    %Document{}
    |> Document.changeset(params)
    |> Repo.insert
  end

  # @spec store_image(binary) :: {:ok, binary} || {:error, }
  defp store_image(file) do
    decode_image(file)
    |> create_filename
    |> File.store
  end

  # @spec file_url(binary) :: {:ok, binary} || {:error, :not_found}
  defp file_url(filename) do
    case File.url(filename) do
      nil -> {:error, :not_found}
      url -> {:ok, url}
    end
  end

  # @spec insert_photo(binary, binary, binary, binary) :: {:ok, } || {:error, }
  defp insert_photo(file_url, file_hash, media_type, document_id) do
    params = %{
      file: file_url,
      file_hash: file_hash,
      type: media_type,
      document_id: document_id
    }

    %Photo{}
    |> Photo.changeset(params)
    |> Repo.insert
  end

  defp decode_image(file) do
    case Base.decode64(file) do
      {:ok, binary} -> binary
      :error -> nil
    end
  end

  defp create_filename(binary) do
    try do
      name = binary
      |> image_extension()
      |> unique_filename()
      |> to_charlist

      %{filename: name, binary: binary}
    rescue
      e in RuntimeException -> IO.inspect e
    end
  end
  
  defp image_extension(<<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _::binary>>), do: ".png"
  defp image_extension(<<0xff, 0xD8, _::binary>>), do: ".jpg"
  defp image_extension(binary), do: throw "Invalid image extension: #{binary}"

  defp unique_filename(extension), do: UUID.uuid4(:hex) <> extension

  defp url_from_photo(photo) do
    url = {photo.file, photo}
    |> File.url

    {:ok, url}
  end

  defp pretty_errors(changeset) do
    errors = for {_key, {message, _}} <- changeset.errors, do: "#{message}"
    {:error, errors}
  end
end
