use Mix.Config

config :rp_quorum, 
  namespace: RpQuorum,
  account_address: System.get_env("RELAYING_QUORUM_ADDRESS") || "0x2fd09b326afe28e5c3b9fa920bb0e094335a22bb"

config :ethereumex, url: System.get_env("QUORUM_URL") || "http://51.144.109.43:22000"

config :logger, level: :info