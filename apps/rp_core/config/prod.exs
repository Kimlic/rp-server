use Mix.Config

config :rp_core, RpCore.Repo,
    adapter: Ecto.Adapters.Postgres,
    database: System.get_env("DB") || "rp_server",
    username: System.get_env("DB_USERNAME") || "kimlic",
    password: System.get_env("DB_PASSWORD") || "kimlic",
    hostname: System.get_env("DB_HOSTNAME") || "localhost",
    port: System.get_env("DB_PORT") || "5432",
    pool_size: Integer.parse(System.get_env("DB_POOL") || "10")

config :arc_azure,
    container: System.get_env("AZURE_CONTAINER") || "rp-blob",
    cdn_url: System.get_env("AZURE_CDN_URL") || "https://blobpharos.blob.core.windows.net"

config :ex_azure,
    account: System.get_env("AZURE_ACCOUNT") || "blobpharos",
    access_key: System.get_env("AZURE_KEY") || "nlXVNa5YkfiYa9UdqMPRb4WdfjqfB5u4KWh0mWLoPxAkxMlSxxUDyqrG3mGrUcQHdTUboG8JTUjGL0BJwwvdDA=="

config :logger, level: :info   