defmodule RpCore.Repo.Migrations.CreateAttestatorsTable do
  use Ecto.Migration

  def change do
    create table :attestators, primary_key: false, prefix: "rp_core" do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :cost_per_user, :float, null: false, default: 0.0
      add :compliance, {:array, :string}
      add :response, :interval
      add :rating, :integer, null: false, default: 0
      add :status, :boolean, null: false, default: false

      timestamps()
    end
  end
end
