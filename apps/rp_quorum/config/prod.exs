use Mix.Config

config :rp_quorum, 
  account_address: "0x7104d3f287274ff695893350c845633e4369126f", # System.get_env("RELAYING_QUORUM_ADDRESS")
  kimlic_token_address: "0xdd90f89509ea1c1fc7ff95985c817b9a17f87e64"
  
config :ethereumex, url: "http://40.117.78.52:22000" # System.get_env("QUORUM_URL")