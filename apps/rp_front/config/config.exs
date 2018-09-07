use Mix.Config

config :rp_front, namespace: RpFront

config :rp_front, RpFrontWeb.Endpoint,
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [view: RpFrontWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: RpFront.PubSub, adapter: Phoenix.PubSub.PG2],
  server: true

config :phoenix, :serve_endpoints, true
config :phoenix, :format_encoders, "json-api": Jason
config :phoenix, :json_library, Jason

config :mime, :types, %{"application/vnd.api+json" => ["json-api"]}

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "#{Mix.env}.exs"
