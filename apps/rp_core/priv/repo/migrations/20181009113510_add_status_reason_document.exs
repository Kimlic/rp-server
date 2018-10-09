defmodule RpCore.Repo.Migrations.AddStatusReasonDocument do
  use Ecto.Migration

  def change do
    alter table :documents, prefix: "rp_core" do
      add :status, :string
      add :reason, :string
    end
  end
end
