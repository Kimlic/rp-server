defmodule RpUaf.Repo.Migrations.CreateScopeRequestsTable do
  use Ecto.Migration

  def change do
    create table :scope_requests, primary_key: false, prefix: "rp_uaf" do
      add :id, :uuid, primary_key: true
      add :status, :citext, null: false
      add :scopes, :citext, null: false
      add :used, :boolean, null: false, default: false
      add :account_address, :citext
      timestamps(type: :utc_datetime)
    end

    create index :scope_requests, :account_address, prefix: "rp_uaf"
  end
end
