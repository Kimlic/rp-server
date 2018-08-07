use Mix.Config

config :rp_mobile, RpMobileWeb.Endpoint,
  secret_key_base: System.get_env("MOBILE_KEY_BASE") || "TaRwP6iMHBxzDxN3A3nhQ649q86wLxR2tw4oKOTpJpIDdKNbmnDcg4WvQCcC79yY",
  url: [host: System.get_env("MOBILE_HOST") || "localhost", port: System.get_env("MOBILE_PORT") || "4000"],
  http: [port: System.get_env("MOBILE_PORT") || "4000"],
  static_url: [
    scheme: "https",
    host: System.get_env("MOBILE_STATIC_HOST") || "localhost",
    port: 443
  ],
  debug_errors: false,
  code_reloader: false

config :logger, level: :info