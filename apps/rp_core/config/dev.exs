use Mix.Config

config :rp_core, RpCore.Repo,
  # database: "rp_server",
  # username: "kimlic@rp3",
  # password: "LU6dME4NzQ",
  # hostname: "rp3.postgres.database.azure.com",
  username: "kimlic",
  password: "kimlic",
  hostname: "localhost",
  pool_size: 10

config :rp_core,
  azure_container: "rp-blob", # System.get_env("AZURE_CONTAINER"),
  azure_cdn_url: "https://stagerp2blob.blob.core.windows.net" # System.get_env("AZURE_CDN_URL")

config :ex_azure,
  account: "stagerp2blob", # System.get_env("AZURE_ACCOUNT"),
  access_key: "vVxIFU45rfYw3Z5uGP0IxLaEHgENxG0JurOZYrEprDH9T4SC2atbGZfrc11CM9LIh0dSRYHOpb1wF+ZmaWrCiQ==" # System.get_env("AZURE_KEY")
