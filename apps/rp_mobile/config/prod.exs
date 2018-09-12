use Mix.Config

config :rp_mobile, RpMobileWeb.Endpoint,
  secret_key_base: System.get_env("MOBILE_KEY_BASE"),
  url: [
    host: System.get_env("MOBILE_HOST"), 
    port: System.get_env("MOBILE_PORT")
  ],
  http: [port: System.get_env("MOBILE_PORT")],
  debug_errors: false,
  catch_errors: true,
  code_reloader: false