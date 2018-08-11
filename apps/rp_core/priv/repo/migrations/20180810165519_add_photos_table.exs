defmodule RpCore.Repo.Migrations.AddPhotosTable do
  use Ecto.Migration

  def change do
    create table :photos, primary_key: false, prefix: "rp_core" do
      add :id, :uuid, primary_key: true
      add :file, :string, null: false
      add :file_hash, :string, null: false
      add :type, :citext, null: false

      add :document_id, references(:documents, on_delete: :delete_all, type: :uuid)

      timestamps()
    end

    create index :photos, :document_id, prefix: "rp_core"
    create unique_index :photos, :file_hash, prefix: "rp_core"
  end
end
 