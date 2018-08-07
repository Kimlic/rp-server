use Mix.Config

config :rp_mobile, namespace: RpMobile

config :rp_mobile, RpMobileWeb.Endpoint,
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [view: RpMobileWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: RpMobile.PubSub, adapter: Phoenix.PubSub.PG2],
  server: true

config :phoenix, :serve_endpoints, true
config :phoenix, :format_encoders, "json-api": Jason
config :phoenix, :json_library, Jason

config :mime, :types, %{"application/vnd.mobile-api.v1+json" => [:v1]}

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "#{Mix.env}.exs"
