defmodule RpCore.Media.Image do
  
  def base64_to_binary(file) do
    case Base.decode64(file) do
      {:ok, binary} -> binary
      :error -> nil
    end
  end

  def image_extension(<<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, _::binary>>), do: ".png"
  def image_extension(<<0xff, 0xD8, _::binary>>), do: ".jpg"
  def image_extension(binary), do: throw "Invalid image extension: #{binary}"

  def unique_filename(extension), do: UUID.uuid4(:hex) <> extension
end