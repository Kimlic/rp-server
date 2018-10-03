defmodule RpKimcore.Schema do
  @moduledoc false

  defmacro __using__(_) do
    quote do
        use Ecto.Schema

        import Ecto.Changeset

        alias RpKimcore.Schema.{Config, Attestator}
    end
  end
end
