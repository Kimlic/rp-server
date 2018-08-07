defmodule RpCore.Media.Upload do
  @moduledoc false

  alias RpCore.Repo
  alias RpCore.Uploader.File
  alias RpCore.Model.Photo
  
  ##### Public #####

  @spec handle(binary, binary) :: {:ok, binary} | {:error, binary}
  def handle(file, account_address) do
    {:ok, filename} = file
    |> decode_image
    |> create_filename
    |> File.store

    path = File.url(filename)
    params = %{
      file: path,
      account_address: account_address
    }

    {:ok, photo} = %Photo{}
    |> Photo.changeset(params)
    |> Repo.insert

    url = {photo.file, photo}
    |> File.url
    
    {:ok, url}
  end

  ##### Private #####

  defp decode_image(file) do
    {:ok, binary} = Base.decode64(file)
    binary
  end

  defp create_filename(binary) do
    name = binary
    |> image_extension()
    |> unique_filename()
    |> to_charlist

    %{filename: name, binary: binary}
  end
  
  defp image_extension(<<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _::binary>>), do: ".png"
  defp image_extension(<<0xff, 0xD8, _::binary>>), do: ".jpg"
  defp image_extension(_), do: throw "Invalid image extension"

  defp unique_filename(extension), do: UUID.uuid4(:hex) <> extension
end
