use Mix.Config

config :rp_uaf, RpUaf.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: System.get_env("DB"),
  username: System.get_env("DB_USERNAME"),
  password: System.get_env("DB_PASSWORD"),
  hostname: System.get_env("DB_HOSTNAME"),
  port: System.get_env("DB_PORT"),
  pool_size: Integer.parse(System.get_env("DB_POOL"))

config :rp_uaf, 
  callback_url: System.get_env("RELAYING_CALLBACK_URL")

config :rp_uaf, RpUaf.Fido.Client,
  url: System.get_env("FIDO_ENDPOINT")