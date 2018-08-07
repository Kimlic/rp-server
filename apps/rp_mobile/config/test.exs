use Mix.Config

config :rp_mobile, RpMobileWeb.Endpoint,
  http: [port: 5000],
  server: false

config :logger, level: :warn
