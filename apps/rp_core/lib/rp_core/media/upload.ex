defmodule RpCore.Media.Upload do
  @moduledoc false

  alias RpCore.Repo
  alias RpCore.Uploader.File
  alias RpCore.Model.{Document, Photo, LogosCompany, Attestator}
  
  ##### Public #####

  @spec create_document(binary, binary, binary, binary, binary, binary) :: {:ok, binary} | {:error, binary}
  def create_document(user_address, doc_type, session_tag, first_name, last_name, country) do
    {:ok, veriff} = Attestator.veriff()

    params = %{
      user_address: user_address,
      type: doc_type,
      session_tag: session_tag,
      first_name: first_name, 
      last_name: last_name, 
      country: country,
      attestator_id: veriff.id
    }

    %Document{}
    |> Document.changeset(params)
    |> Repo.insert
  end

  def create_photo(document_id, media_type, file, file_hash) do
    with {:ok, filename} <- store_image(file),
    {:ok, url} <- file_url(filename),
    {:ok, photo} <- insert_photo(url, file_hash, media_type, document_id) do
      {:ok, photo}
    else
      {:error, :not_found} -> {:error, "No photo uploaded"}
      {:error, changeset} -> pretty_errors(changeset)
      err -> IO.puts "ERROR: #{inspect err}"
    end
  end

  def create_logo(company_id, file) do
    LogosCompany.delete_all()

    with {:ok, logo} <- insert_logo(file, company_id) do
      {:ok, logo}
    else
      {:error, :not_found} -> {:error, "No logo uploaded"}
      {:error, changeset} -> pretty_errors(changeset)
      err -> IO.puts "ERROR: #{inspect err}"
    end
  end

  ##### Private #####

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

  defp insert_logo(file, company_id) do
    params = %{
      file: file,
      company_id: company_id
    }
    
    %LogosCompany{}
    |> LogosCompany.changeset(params)
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
      e in RuntimeException -> IO.puts "Exception: #{inspect e}"
    end
  end
  
  defp image_extension(<<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _::binary>>), do: ".png"
  defp image_extension(<<0xff, 0xD8, _::binary>>), do: ".jpg"
  defp image_extension(binary), do: throw "Invalid image extension: #{binary}"

  defp unique_filename(extension), do: UUID.uuid4(:hex) <> extension
  
  defp pretty_errors(changeset) do
    errors = for {_key, {message, _}} <- changeset.errors, do: "#{message}"
    {:error, errors}
  end
end
