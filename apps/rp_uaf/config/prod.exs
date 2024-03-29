use Mix.Config

config :rp_uaf, RpUaf.Repo,
  #username: "kimlic@stage-postgresql-rp1", # System.get_env("DB_USERNAME"),
  username: "kimlic", # System.get_env("DB_USERNAME"),
  password: "LU6dME4NzQ", # System.get_env("DB_PASSWORD"),
  #hostname: "stage-postgresql-rp1.postgres.database.azure.com", # System.get_env("DB_HOSTNAME"),
  hostname: "stage-postgresql-rp1.eastus.cloudapp.azure.com", # System.get_env("DB_HOSTNAME"),
  pool_size: 5 # System.get_env("DB_POOL") |> Integer.parse |> elem(0)

config :rp_uaf, 
  callback_url: "https://demo.kimlic.com/api/qr_callback" # System.get_env("RELAYING_CALLBACK_URL")

config :rp_uaf, RpUaf.Fido.Client,
  url: "http://40.76.65.192:8080/fidouaf/v1/public" # System.get_env("FIDO_ENDPOINT")
