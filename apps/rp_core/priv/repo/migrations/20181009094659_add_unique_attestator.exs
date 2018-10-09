defmodule RpCore.Repo.Migrations.AddUniqueAttestator do
  use Ecto.Migration

  def change do
    create unique_index :attestators, :name, prefix: "rp_core"
  end
end
