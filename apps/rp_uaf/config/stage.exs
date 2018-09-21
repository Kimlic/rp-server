use Mix.Config

config :rp_uaf, RpUaf.Repo,
  #username: "kimlic@stage-postgres-pr2", # System.get_env("DB_USERNAME"),
  username: "kimlic", # System.get_env("DB_USERNAME"),
  password: "LU6dME4NzQ", # System.get_env("DB_PASSWORD"),
  #hostname: "stage-postgres-pr2.postgres.database.azure.com", # System.get_env("DB_HOSTNAME"),
  hostname: "stage-postgresql.eastus.cloudapp.azure.com", # System.get_env("DB_HOSTNAME"),
  pool_size: 20 # System.get_env("DB_POOL") |> Integer.parse |> elem(0)

config :rp_uaf, 
  callback_url: "http://168.62.55.56:4002/api/qr_callback" # System.get_env("RELAYING_CALLBACK_URL")

config :rp_uaf, RpUaf.Fido.Client,
  url: "http://23.96.96.65:8080/fidouaf/v1/public" # System.get_env("FIDO_ENDPOINT")
