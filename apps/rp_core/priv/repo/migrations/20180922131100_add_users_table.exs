defmodule RpCore.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table :users, primary_key: false, prefix: "rp_core" do
      add :id, :uuid, primary_key: true
      add :first_name, :string, null: false
      add :last_name, :string, null: false

      add :role_id, references(:roles, on_delete: :nothing)

      timestamps()
    end

    create index :users, :role_id, prefix: "rp_core"
  end
end
