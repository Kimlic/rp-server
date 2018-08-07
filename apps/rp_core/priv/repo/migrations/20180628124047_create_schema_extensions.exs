defmodule RpCore.Repo.Migrations.CreateSchemaExtensions do
  use Ecto.Migration

  def change do
    execute "SET max_parallel_workers_per_gather TO 8;"
    execute "CREATE EXTENSION IF NOT EXISTS citext;"
    execute "CREATE SCHEMA IF NOT EXISTS rp_core;"
  end
end
