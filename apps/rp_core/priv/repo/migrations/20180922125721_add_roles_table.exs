defmodule RpCore.Repo.Migrations.AddRolesTable do
  use Ecto.Migration

  def change do
    create table :roles, prefix: "rp_core" do
      add :name, :string, null: false
    end
  end
end
