use Mix.Config

config :task_bunny,
  hosts: [
    default: [
      connect_options: System.get_env("RABBIT_CONNECT_OPTIONS")
    ]
  ]

config :logger, level: :info