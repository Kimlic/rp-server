defmodule RpCore.Repo.Migrations.AddVerifiedToDocument do
  use Ecto.Migration

  def up do
    alter table :documents, prefix: "rp_core" do
      add :verified_at, :utc_datetime
      add :verified, :boolean, null: false, default: false
    end
  end
end
