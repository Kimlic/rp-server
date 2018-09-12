use Mix.Config

config :rp_uaf, RpUaf.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "rp_server",
  username: "kimlic",
  password: "kimlic",
  hostname: "localhost",
  port: "5432",
  timeout: 60_000,
  pool_timeout: 60_000,
  ownership_timeout: 60_000,
  pool_size: 10,
  parameters: [application_name: "RpCore", statement_timeout: "5000"]

config :rp_uaf,
  callback_url: "http://localhost:4000/api/qr_callback"

config :rp_uaf, RpUaf.Fido.Client, 
  url: "http://localhost:8080/fidouaf/v1/public"