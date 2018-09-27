use Mix.Config
  
config :rp_core, RpCore.Repo,
  #username: "kimlic@stage-postgres-pr2", # System.get_env("DB_USERNAME"),
  username: "kimlic", # System.get_env("DB_USERNAME"),
  password: "LU6dME4NzQ", # System.get_env("DB_PASSWORD"),
  #hostname: "stage-postgres-pr2.postgres.database.azure.com", # System.get_env("DB_HOSTNAME"),
  hostname: "stage-postgresql.eastus.cloudapp.azure.com", # System.get_env("DB_HOSTNAME"),
  pool_size: 5 # System.get_env("DB_POOL") |> Integer.parse |> elem(0)

config :rp_core,
  azure_container: "rp-blob", # System.get_env("AZURE_CONTAINER"),
  azure_cdn_url: "https://stagerp2blob.blob.core.windows.net" # System.get_env("AZURE_CDN_URL")

config :ex_azure,
  account: "stagerp2blob", # System.get_env("AZURE_ACCOUNT"),
  access_key: "vVxIFU45rfYw3Z5uGP0IxLaEHgENxG0JurOZYrEprDH9T4SC2atbGZfrc11CM9LIh0dSRYHOpb1wF+ZmaWrCiQ==" # System.get_env("AZURE_KEY")
