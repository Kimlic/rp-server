use Mix.Config

config :task_bunny,
  hosts: [
    default: [
      connect_options: System.get_env("RABBIT_CONNECT_OPTIONS") || "amqp://kimlic:kimlic@localhost:5672?heartbeat=30"
    ]
  ]

config :logger, level: :info