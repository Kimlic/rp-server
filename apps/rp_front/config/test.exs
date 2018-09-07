use Mix.Config

config :rp_front, RpFrontWeb.Endpoint,
  secret_key_base: "TaRwP6iMHBxzDxN3A3nhQ649q86wLxR2tw4oKOTpJpIDdKNbmnDcg4WvQCcC79yY",
  http: [port: 5001],
  server: false

config :logger, level: :warn
