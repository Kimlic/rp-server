use Mix.Config

config :rp_uaf,
  namespace: RpUaf,
  ecto_repos: [RpUaf.Repo],
  generators: [binary_id: true]

config :rp_uaf,
  requested_scopes: ~w(email phone),
  scope_request_ttl: 1_000

import_config "#{Mix.env()}.exs"