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

config :arc_azure,
  container: "rp-blob",
  cdn_url: "https://stagerpblob.blob.core.windows.net"

config :ex_azure,
  account: "stagerpblob",
  access_key: "65tC8WoorHTSrbp90h/hJf7OXQJtdQMWDVJMoE1Ra5U5L+wLNT2F46o5G4hDMgtYKyP1U5YdRvXqIigKvbohHg=="