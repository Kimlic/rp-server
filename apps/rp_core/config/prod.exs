use Mix.Config

config :rp_core, RpCore.Repo,
  database: System.get_env("DB"),
  username: System.get_env("DB_USERNAME"),
  password: System.get_env("DB_PASSWORD"),
  hostname: System.get_env("DB_HOSTNAME"),
  pool_size: System.get_env("DB_POOL") |> Integer.parse |> elem(0)

config :arc_azure,
  container: System.get_env("AZURE_CONTAINER"),
  cdn_url: System.get_env("AZURE_CDN_URL")

config :ex_azure,
  account: System.get_env("AZURE_ACCOUNT"),
  access_key: System.get_env("AZURE_KEY")