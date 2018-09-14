use Mix.Config

config :rp_quorum, account_address: System.get_env("RELAYING_QUORUM_ADDRESS")

config :ethereumex, url: System.get_env("QUORUM_URL")