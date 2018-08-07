use Mix.Config

config :rp_uaf, RpUaf.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: System.get_env("DB") || "rp_server",
  username: System.get_env("DB_USERNAME") || "kimlic",
  password: System.get_env("DB_PASSWORD") || "kimlic",
  hostname: System.get_env("DB_HOSTNAME") || "localhost",
  port: System.get_env("DB_PORT") || "5432",
  pool_size: Integer.parse(System.get_env("DB_POOL") || "10")

config :rp_uaf, 
  callback_url: System.get_env("RELAYING_CALLBACK_URL")

config :rp_uaf, RpUaf.Fido.Client,
  url: System.get_env("FIDO_ENDPOINT")

config :logger, level: :info   