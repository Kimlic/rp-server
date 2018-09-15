use Mix.Config

config :rp_quorum, namespace: RpQuorum

config :rp_quorum, transaction_delay: 2500
  
import_config "#{Mix.env}.exs"
