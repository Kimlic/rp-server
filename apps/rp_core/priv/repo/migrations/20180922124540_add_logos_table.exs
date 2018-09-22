defmodule RpCore.Repo.Migrations.AddLogosTable do
  use Ecto.Migration

  def change do
    create table :logos, primary_key: false, prefix: "rp_core" do
      add :id, :uuid, primary_key: true
      add :file, :string, null: false

      add :company_id, references(:companys, on_delete: :delete_all, type: :uuid)

      timestamps()
    end

    create index :logos, :company_id, prefix: "rp_core"
  end
end
