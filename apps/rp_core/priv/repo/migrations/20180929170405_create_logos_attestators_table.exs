defmodule RpCore.Repo.Migrations.CreateLogosAttestatorsTable do
  use Ecto.Migration

  def change do
    create table :logos_attestators, primary_key: false, prefix: "rp_core" do
      add :id, :uuid, primary_key: true
      add :file, :string, null: false

      add :attestator_id, references(:attestators, on_delete: :delete_all, type: :uuid)

      timestamps()
    end

    create index :logos_attestators, :attestator_id, prefix: "rp_core"
  end
end
