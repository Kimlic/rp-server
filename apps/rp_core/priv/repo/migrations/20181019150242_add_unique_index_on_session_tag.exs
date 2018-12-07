defmodule RpCore.Repo.Migrations.AddUniqueIndexOnSessionTag do
  use Ecto.Migration

  def change do
    create unique_index :documents, :session_tag, prefix: "rp_core"
  end
end
