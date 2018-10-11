defmodule RpCore.Repo.Migrations.MakeCountryDocumentsOptional do
  use Ecto.Migration

  def change do
    alter table :documents, prefix: "rp_core" do
      modify :country, :string, null: true
    end
  end
end
