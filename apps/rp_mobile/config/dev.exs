use Mix.Config

config :rp_mobile, RpMobileWeb.Endpoint,
  debug_errors: false,
  catch_errors: true,
  code_reloader: true,
  check_origin: false

config :phoenix, :stacktrace_depth, 20

config :rp_mobile, RpMobileWeb.Endpoint, live_reload: [
  patterns: [
    ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
    ~r{priv/gettext/.*(po)$},
    ~r{web/views/.*(ex)$},
    ~r{web/templates/.*(eex)$}
  ]
]