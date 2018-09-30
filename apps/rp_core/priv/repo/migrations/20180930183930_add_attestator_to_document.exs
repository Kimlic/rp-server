defmodule RpCore.Repo.Migrations.AddAttestatorToDocument do
  use Ecto.Migration

  def change do
    alter table :documents, prefix: "rp_core" do
      add :attestator_id, references(:attestators, on_delete: :nothing, type: :uuid)
    end

    create index :documents, :attestator_id, prefix: "rp_core"
  end
end
