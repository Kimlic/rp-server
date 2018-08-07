defmodule RpUaf.Repo.Migrations.CreateAuthenticatorsTable do
  use Ecto.Migration

  def change do
    create table :authenticators, primary_key: false, prefix: "rp_uaf" do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :key_id, :citext, null: false
      add :device_id, :citext, null: true
      add :aaid, :citext, null: false
      add :status, :string, null: true, size: 20
      add :account_address, :citext, null: false
      add :inserted_at, :naive_datetime, default: fragment("now()")
      add :updated_at, :naive_datetime, default: fragment("now()")
    end

    create unique_index :authenticators, :key_id, prefix: "rp_uaf"
  end
end
