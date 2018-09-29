defmodule RpCore.Model do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      use RpCore.Schema
  
      import Ecto.Changeset
      import Ecto.Query
      import Ecto.Interval

      alias RpCore.Repo
      alias RpCore.Model.{
        Document, 
        Photo, 
        Company, 
        Role, 
        User, 
        LogosCompany, 
        Attestator,
        LogosAttestator
      }
    end
  end
end
  