use Mix.Config

config :rp_dashboard, namespace: RpDashboard

config :rp_dashboard, RpDashboardWeb.Endpoint,
  url: [host: "localhost", port: 4003],
  http: [:inet6, port: 4003],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  secret_key_base: "TaRwP6iMHBxzDxN3A3nhQ649q86wLxR2tw4oKOTpJpIDdKNbmnDcg4WvQCcC79yY",
  static_url: [
    scheme: "https",
    host: "localhost",
    port: 4003
  ],
  render_errors: [view: RpDashboardWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: ApiMobile.PubSub, adapter: Phoenix.PubSub.PG2],
  server: true,
  watchers: []

config :phoenix, :serve_endpoints, true
config :phoenix, :format_encoders, "json-api": Jason
config :phoenix, :json_library, Jason

import_config "#{Mix.env}.exs"