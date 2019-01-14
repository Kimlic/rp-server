defmodule RpCore.Schema do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
  
      @schema_prefix "rp_core"
    end
  end
end  