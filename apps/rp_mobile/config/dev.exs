use Mix.Config

config :rp_mobile,
  endpoint: "http://localhost:4002"
  
config :rp_mobile, RpMobileWeb.Endpoint,
  debug_errors: false,
  catch_errors: true,
  code_reloader: true,
  check_origin: false

config :rp_mobile, RpMobileWeb.Endpoint, live_reload: [
  patterns: [
    ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
    ~r{priv/gettext/.*(po)$},
    ~r{web/views/.*(ex)$},
    ~r{web/templates/.*(eex)$}
  ]
]

config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime