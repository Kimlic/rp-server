use Mix.Config

config :rp_attestation,
  account_address: "0x7104d3f287274ff695893350c845633e4369126f", # System.get_env("RELAYING_QUORUM_ADDRESS"),
  ap_endpoint: "http://40.87.64.171:4001/api" # System.get_env("ATTESTATION_ENDPOINT")