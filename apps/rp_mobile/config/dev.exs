use Mix.Config

config :rp_mobile, RpMobileWeb.Endpoint,
  secret_key_base: "TaRwP6iMHBxzDxN3A3nhQ649q86wLxR2tw4oKOTpJpIDdKNbmnDcg4WvQCcC79yY",
  url: [host: "localhost", port: 4000],
  http: [port: 4000],
  static_url: [
    scheme: "https",
    host: "localhost",
    port: 443
  ],
  debug_errors: true,
  catch_errors: false,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :phoenix, :stacktrace_depth, 20

config :rp_mobile, RpMobileWeb.Endpoint, live_reload: [
  patterns: [
    ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
    ~r{priv/gettext/.*(po)$},
    ~r{web/views/.*(ex)$},
    ~r{web/templates/.*(eex)$}
  ]]

config :logger, level: :debug
config :logger, :console, format: "[$level] $message\n"