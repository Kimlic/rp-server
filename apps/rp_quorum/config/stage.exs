use Mix.Config

config :rp_quorum, 
  account_address: "0xaea9433841ec55397f9890a3b412ed74ecf8e7b3", # System.get_env("RELAYING_QUORUM_ADDRESS")
  kimlic_token_address: "0x9fa4f8941e00fe28691eab8489e9b07e516e0db2"

config :ethereumex, url: "http://23.96.100.231:22000" # System.get_env("QUORUM_URL")