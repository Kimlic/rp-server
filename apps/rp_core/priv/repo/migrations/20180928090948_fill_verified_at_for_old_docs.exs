defmodule RpCore.Repo.Migrations.FillVerifiedAtForOldDocs do
  use Ecto.Migration

  import Ecto.Query

  alias RpCore.Model.Document
  alias RpCore.Repo

  def change do
    Application.ensure_all_started(:tzdata)

    query = from d in Document,
      where: is_nil(d.verified_at)

    query
    |> Repo.all
    |> Enum.map(fn doc -> 
      doc
      |> Document.changeset(%{
        verified_at: Timex.shift(doc.inserted_at, hours: 2),
        verified: true
      })
      |> Repo.update
    end)
  end
end
