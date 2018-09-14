use Mix.Config

config :rp_core,
  namespace: RpCore,
  ecto_repos: [RpCore.Repo]

config :rp_core, RpCore.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "rp_server",
  port: "5432",
  timeout: 15_000,
  pool_timeout: 15_000,
  ownership_timeout: 15_000,
  parameters: [application_name: "RpCore", statement_timeout: "5000"]

config :arc, storage: Arc.Storage.Azure

import_config "#{Mix.env()}.exs"