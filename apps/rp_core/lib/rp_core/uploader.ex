defmodule RpCore.Uploader do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      use Arc.Ecto.Schema

      alias RpCore.Uploader.File
    end
  end
end