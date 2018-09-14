use Mix.Config

config :rp_uaf, RpUaf.Repo,
  username: "kimlic@stage-postgresql-rp1", # System.get_env("DB_USERNAME"),
  password: "LU6dME4NzQ", # System.get_env("DB_PASSWORD"),
  hostname: "stage-postgresql-rp1.postgres.database.azure.com", # System.get_env("DB_HOSTNAME"),
  pool_size: 10 # System.get_env("DB_POOL") |> Integer.parse |> elem(0)

config :rp_uaf, 
  callback_url: "http://13.68.143.152:4002/api/qr_callback" # System.get_env("RELAYING_CALLBACK_URL")

config :rp_uaf, RpUaf.Fido.Client,
  url: "http://40.76.65.192:8080/fidouaf/v1/public" # System.get_env("FIDO_ENDPOINT")