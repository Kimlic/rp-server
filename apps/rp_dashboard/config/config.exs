use Mix.Config

config :rp_dashboard, namespace: RpDashboard

config :rp_dashboard, RpDashboardWeb.Endpoint,
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [view: RpDashboardWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: RpDashboard.PubSub, adapter: Phoenix.PubSub.PG2],
  server: true

config :phoenix, :serve_endpoints, true
config :phoenix, :format_encoders, "json-api": Jason
config :phoenix, :json_library, Jason

config :mime, :types, %{"application/vnd.api+json" => ["json-api"]}

# config :logger, :debug_dashboard,
#   path: "logs/rp_dashboard/debug.log",
#   format: "[$date] [$time] [$level] $metadata $message\n",
#   metadata: [:request_id, :application, :module, :function, :crash_reason],
#   level: :debug,
#   metadata_filter: [application: :absinthe]

# config :logger, :error_dashboard,
#   path: "logs/rp_dashboard/error.log",
#   format: "[$date] [$time] [$level] $metadata $message\n",
#   metadata: [:request_id, :application, :module, :function, :crash_reason],
#   level: :error,
#   metadata_filter: [application: :absinthe]

import_config "#{Mix.env}.exs"