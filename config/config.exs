use Mix.Config

import_config "../apps/*/config/config.exs"

config :logger, :console,
    level: :info,
    format: "$date $time [$level] $metadata$message\n",
    handle_otp_reports: true