use Mix.Config

config :rp_uaf, RpUaf.Repo,
  username: System.get_env("DB_USERNAME"),
  password: System.get_env("DB_PASSWORD"),
  hostname: System.get_env("DB_HOSTNAME"),
  pool_size: System.get_env("DB_POOL") |> Integer.parse |> elem(0)

config :rp_uaf, 
  callback_url: System.get_env("RELAYING_CALLBACK_URL")

config :rp_uaf, RpUaf.Fido.Client,
  url: System.get_env("FIDO_ENDPOINT")