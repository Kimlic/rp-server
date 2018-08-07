defmodule RpCore.Model do
    @moduledoc false

    defmacro __using__(_) do
        quote do
            use RpCore.Schema
  
            import Ecto.Changeset
            import Ecto.Query
        end
    end
end
  