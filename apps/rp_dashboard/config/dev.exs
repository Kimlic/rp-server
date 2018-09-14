use Mix.Config

config :rp_dashboard, RpDashboardWeb.Endpoint,
  debug_errors: false,
  catch_errors: true,
  code_reloader: true,
  check_origin: false

config :phoenix, :stacktrace_depth, 20