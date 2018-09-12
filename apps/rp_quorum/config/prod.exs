use Mix.Config

config :rp_quorum, 
  namespace: RpQuorum,
  account_address: System.get_env("RELAYING_QUORUM_ADDRESS")

config :ethereumex, url: System.get_env("QUORUM_URL")