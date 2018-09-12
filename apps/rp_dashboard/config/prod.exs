use Mix.Config

config :rp_dashboard, RpDashboardWeb.Endpoint,
  secret_key_base: System.get_env("FRONT_KEY_BASE"),
  url: [host: System.get_env("FRONT_HOST"), port: System.get_env("FRONT_PORT")],
  http: [port: System.get_env("FRONT_PORT")],
  static_url: [
    scheme: "https",
    host: System.get_env("FRONT_STATIC_HOST"),
    port: 443
  ],
  debug_errors: false,
  code_reloader: false