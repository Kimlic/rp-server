defmodule RpUaf.Model do
  @moduledoc false

  defmacro __using__(_) do
      quote do
          use RpUaf.Schema

          import Ecto.Changeset
          import Ecto.Query
      end
  end
end
