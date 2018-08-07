defmodule RpUaf.Repo.Migrations.CreateSchemaExtensions do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS pgcrypto;"
    execute "CREATE SCHEMA IF NOT EXISTS rp_uaf;"
  end
end