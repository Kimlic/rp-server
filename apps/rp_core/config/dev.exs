use Mix.Config

config :rp_core, RpCore.Repo,
  adapter: Ecto.Adapters.Postgres,
  # database: "rp_server",
  # username: "kimlic@rp3",
  # password: "LU6dME4NzQ",
  # hostname: "rp3.postgres.database.azure.com",
  database: "rp_server",
  username: "kimlic",
  password: "kimlic",
  hostname: "localhost",
  port: "5432",
  timeout: 15_000,
  pool_timeout: 15_000,
  ownership_timeout: 15_000,
  pool_size: 10,
  parameters: [application_name: "RpCore", statement_timeout: "5000"]

config :arc_azure,
  container: "rp-blob",
  cdn_url: "https://blobpharos.blob.core.windows.net"

config :ex_azure,
  account: "blobpharos",
  access_key: "nlXVNa5YkfiYa9UdqMPRb4WdfjqfB5u4KWh0mWLoPxAkxMlSxxUDyqrG3mGrUcQHdTUboG8JTUjGL0BJwwvdDA=="