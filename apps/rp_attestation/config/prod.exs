use Mix.Config

config :rp_attestation,
  account_address: System.get_env("RELAYING_QUORUM_ADDRESS"),
  ap_endpoint: System.get_env("ATTESTATION_ENDPOINT")

config :logger, level: :info