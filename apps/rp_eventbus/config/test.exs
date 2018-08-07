use Mix.Config

config :task_bunny,
  hosts: [
    default: [
      connect_options: "amqp://kimlic:kimlic@localhost:5672?heartbeat=30"
    ]
  ]

config :logger, level: :debug