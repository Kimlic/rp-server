use Mix.Config

config :rp_front, RpFrontWeb.Endpoint,
  secret_key_base: "TaRwP6iMHBxzDxN3A3nhQ649q86wLxR2tw4oKOTpJpIDdKNbmnDcg4WvQCcC79yY",
  url: [host: "localhost", port: 4001],
  http: [port: 4001],
  static_url: [
    scheme: "https",
    host: "localhost",
    port: 4001
  ],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :phoenix, :stacktrace_depth, 20

config :logger, level: :debug
config :logger, :console, format: "[$level] $message\n"