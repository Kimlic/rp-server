defmodule RpCore.Repo.Migrations.AddCompanysTable do
  use Ecto.Migration

  def change do
    create table :companys, primary_key: false, prefix: "rp_core" do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :email, :string, null: false
      add :website, :string
      add :phone, :string
      add :address, :string
      add :details, :string

      timestamps()
    end
  end
end
