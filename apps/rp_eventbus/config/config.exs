use Mix.Config

config :rp_eventbus, namespace: RpEventbus

config :task_bunny,
  queue: [
    namespace: "rp_eventbus.#{Mix.env()}.",
    queues: [
      [name: "demo", jobs: [RpEventbus.Job.DemoJob], worker: [concurrency: 10]]
    ]
  ],
  failure_backend: [RpEventbus.Logger.TaskBunny]

import_config "#{Mix.env}.exs"
