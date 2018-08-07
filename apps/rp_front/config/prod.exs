use Mix.Config

config :rp_front, RpFrontWeb.Endpoint,
  secret_key_base: System.get_env("FRONT_KEY_BASE") || "TaRwP6iMHBxzDxN3A3nhQ649q86wLxR2tw4oKOTpJpIDdKNbmnDcg4WvQCcC79yY",
  url: [host: System.get_env("FRONT_HOST") || "localhost", port: System.get_env("FRONT_PORT") || "4001"],
  http: [port: System.get_env("FRONT_PORT") || "4001"],
  static_url: [
    scheme: "https",
    host: System.get_env("FRONT_STATIC_HOST") || "localhost",
    port: 443
  ],
  debug_errors: false,
  code_reloader: false

config :logger, level: :info