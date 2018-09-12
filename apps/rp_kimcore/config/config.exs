use Mix.Config

config :rp_kimcore, namespace: RpKimcore

config :rp_kimcore, 
  kim_config: "/config"
  
import_config "#{Mix.env}.exs"
