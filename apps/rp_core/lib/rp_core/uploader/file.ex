defmodule RpCore.Uploader.File do
  @moduledoc false

  use Arc.Definition
  use Arc.Ecto.Definition

  alias __MODULE__

  @versions [:original]

  ##### Public #####
  
  def file_url(filename) do
    case File.url(filename) do
      nil -> {:error, :not_found}
      url -> {:ok, url}
    end
  end
end
