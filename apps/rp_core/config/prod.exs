use Mix.Config

config :rp_core, RpCore.Repo,
  username: "kimlic@stage-postgresql-rp1", # System.get_env("DB_USERNAME"),
  password: "LU6dME4NzQ", # System.get_env("DB_PASSWORD"),
  hostname: "stage-postgresql-rp1.postgres.database.azure.com", # System.get_env("DB_HOSTNAME"),
  pool_size: 10 # System.get_env("DB_POOL") |> Integer.parse |> elem(0)

# config :arc_azure,
#   container: "rp-blob", # System.get_env("AZURE_CONTAINER"),
#   cdn_url: "https://stagerpblob.blob.core.windows.net" # System.get_env("AZURE_CDN_URL")

# config :ex_azure,
#   account: "stagerpblob", # System.get_env("AZURE_ACCOUNT"),
#   access_key: "65tC8WoorHTSrbp90h/hJf7OXQJtdQMWDVJMoE1Ra5U5L+wLNT2F46o5G4hDMgtYKyP1U5YdRvXqIigKvbohHg==" # System.get_env("AZURE_KEY")

config :arc_azure,
  container: "rp-blob",
  cdn_url: "https://blobpharos.blob.core.windows.net"

config :ex_azure,
  account: "blobpharos",
  access_key: "nlXVNa5YkfiYa9UdqMPRb4WdfjqfB5u4KWh0mWLoPxAkxMlSxxUDyqrG3mGrUcQHdTUboG8JTUjGL0BJwwvdDA=="