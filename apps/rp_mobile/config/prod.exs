use Mix.Config

config :rp_mobile, RpMobileWeb.Endpoint,
  debug_errors: false,
  catch_errors: true,
  code_reloader: false,
  check_origin: false

config :rp_mobile,
  endpoint: "https://demo.kimlic.com"