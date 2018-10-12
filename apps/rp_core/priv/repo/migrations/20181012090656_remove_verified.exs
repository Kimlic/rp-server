defmodule RpCore.Repo.Migrations.RemoveVerified do
  use Ecto.Migration

  def change do
    alter table :documents, prefix: "rp_core" do
      remove :verified
    end
  end
end
