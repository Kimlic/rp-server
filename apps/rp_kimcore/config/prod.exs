use Mix.Config

config :rp_kimcore,
  account_address: System.get_env("RELAYING_QUORUM_ADDRESS") || "0xdfbc3489041d9c3c728b4179c3c358c143c7e98e",
  kim_endpoint: System.get_env("KIM_CORE_ENDPOINT") || "https://mobile-api-test.kimlic.com/api"

config :logger, level: :info