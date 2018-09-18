use Mix.Config

config :rp_attestation,
  account_address: "0xaea9433841ec55397f9890a3b412ed74ecf8e7b3", # System.get_env("RELAYING_QUORUM_ADDRESS"),
  ap_endpoint: "http://40.87.64.171:4001/api" # System.get_env("ATTESTATION_ENDPOINT")