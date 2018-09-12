use Mix.Config

config :rp_kimcore,
  account_address: System.get_env("RELAYING_QUORUM_ADDRESS"),
  kim_endpoint: System.get_env("KIM_CORE_ENDPOINT")