use Mix.Config

config :rp_uaf, RpUaf.Repo,
  #username: "kimlic@stage-postgres-pr2", # System.get_env("DB_USERNAME"),
  username: "kimlic", # System.get_env("DB_USERNAME"),
  password: "LU6dME4NzQ", # System.get_env("DB_PASSWORD"),
  #hostname: "stage-postgres-pr2.postgres.database.azure.com", # System.get_env("DB_HOSTNAME"),
  hostname: "stage-postgresql-rp2.eastus.cloudapp.azure.com", # System.get_env("DB_HOSTNAME"),
  pool_size: 5 # System.get_env("DB_POOL") |> Integer.parse |> elem(0)

# config :rp_core, RpUaf.Repo,
#   username: "kimlic",
#   password: "kimlic",
#   hostname: "localhost",
#   pool_size: 10

config :rp_uaf, 
  callback_url: "https://demo-rp2.kimlic.com/api/qr_callback" # System.get_env("RELAYING_CALLBACK_URL")

config :rp_uaf, RpUaf.Fido.Client,
  url: "http://23.96.96.65:8080/fidouaf/v1/public" # System.get_env("FIDO_ENDPOINT")
