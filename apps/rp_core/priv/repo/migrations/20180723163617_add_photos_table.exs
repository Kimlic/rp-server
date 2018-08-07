defmodule RpCore.Repo.Migrations.AddPhotosTable do
  use Ecto.Migration

  def change do
    create table :photos, primary_key: false, prefix: "rp_core" do
      add :id, :uuid, primary_key: true
      add :account_address, :string, null: false
      add :file, :string, null: false

      timestamps()
    end

    create index :photos, :account_address, prefix: "rp_core"
  end
end
 