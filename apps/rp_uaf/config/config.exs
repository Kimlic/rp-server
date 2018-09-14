use Mix.Config

config :rp_uaf,
  namespace: RpUaf,
  ecto_repos: [RpUaf.Repo],
  generators: [binary_id: true]

config :rp_uaf, RpUaf.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "rp_server",
  port: "5432",
  timeout: 60_000,
  pool_timeout: 60_000,
  ownership_timeout: 60_000,
  parameters: [application_name: "RpUaf", statement_timeout: "5000"]

config :rp_uaf,
  requested_scopes: ~w(email phone),
  scope_request_ttl: 1_000

import_config "#{Mix.env()}.exs"