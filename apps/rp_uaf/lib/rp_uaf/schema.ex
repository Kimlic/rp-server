defmodule RpUaf.Schema do
  @moduledoc false

  defmacro __using__(_) do
      quote do
          use Ecto.Schema

          @schema_prefix "rp_uaf"
      end
  end
end  