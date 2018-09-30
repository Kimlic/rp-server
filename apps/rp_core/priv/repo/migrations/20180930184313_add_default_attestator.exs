defmodule RpCore.Repo.Migrations.AddDefaultAttestator do
  use Ecto.Migration

  import Ecto.Query

  alias RpCore.Model.{Document, Attestator}
  alias RpCore.Repo

  def change do
    Application.ensure_all_started(:tzdata)
    
    veriff = Repo.one from a in Attestator,
      where: a.name == "veriff"
    IO.puts "VERIFF: #{inspect veriff}"
    Repo.all(Document)
    |> Enum.map(fn doc -> 
      IO.puts "DOC: #{inspect doc}"
    
      res = doc
      |> Document.changeset(%{attestator_id: veriff.id})
      |> Repo.update!

      IO.puts "RES: #{inspect res}"
    end)
  end
end
