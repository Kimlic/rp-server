use Mix.Config

config :rp_mobile, namespace: RpMobile

config :rp_mobile, RpMobileWeb.Endpoint,
  secret_key_base: "TaRwP6iMHBxzDxN3A3nhQ649q86wLxR2tw4oKOTpJpIDdKNbmnDcg4WvQCcC79yY",
  url: [host: "localhost", port: 4002],
  http: [port: 4002],
  adapter: Phoenix.Endpoint.Cowboy2Adapter,
  render_errors: [view: RpMobileWeb.ErrorView, accepts: ~w(json)],
  http: [protocol_options: [max_request_line_length: 8192, max_header_value_length: 8192]],
  server: true,
  watchers: []

config :phoenix, :serve_endpoints, true
config :phoenix, :format_encoders, "json-api": Jason
config :phoenix, :json_library, Jason

config :mime, :types, %{"application/vnd.mobile-api.v1+json" => [:v1]}

import_config "#{Mix.env}.exs"
