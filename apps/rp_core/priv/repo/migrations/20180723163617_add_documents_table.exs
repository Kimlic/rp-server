defmodule RpCore.Repo.Migrations.AddDocumentsTable do
  use Ecto.Migration

  def change do
    create table :documents, primary_key: false, prefix: "rp_core" do
      add :id, :uuid, primary_key: true
      add :user_address, :citext, null: false
      add :type, :citext, null: false
      add :session_tag, :string, null: false
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :country, :string, null: false
  
      timestamps()
    end

    create unique_index :documents, [:user_address, :type], prefix: "rp_core"
  end
end
