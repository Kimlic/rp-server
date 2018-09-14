use Mix.Config

config :rp_uaf, RpUaf.Repo,
  # database: "rp_server",
  # username: "kimlic@rp3",
  # password: "LU6dME4NzQ",
  # hostname: "rp3.postgres.database.azure.com",
  username: "kimlic",
  password: "kimlic",
  hostname: "localhost",
  pool_size: 10

config :rp_uaf,
  # callback_url: "http://localhost:4000/api/qr_callback"
  # callback_url: "http://51.141.120.164:4000/api/qr_callback"
  callback_url: "http://127.0.0.1:4002/api/qr_callback"

config :rp_uaf, RpUaf.Fido.Client, 
  # url: "http://localhost:8080/fidouaf/v1/public"
  # url: "http://168.63.46.184:8080/fidouaf/v1/public"
  url: "http://127.0.0.1:8080/fidouaf/v1/public"