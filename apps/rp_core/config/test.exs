use Mix.Config

config :rp_core, RpCore.Repo,
    adapter: Ecto.Adapters.Postgres,
    database: "rp_server",
    username: "kimlic",
    password: "kimlic",
    hostname: "localhost",
    port: "5432",
    pool_size: 10

config :logger, level: :debug 