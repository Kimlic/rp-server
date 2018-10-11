defmodule RpMobileWeb.Metrics.CommandInstrumenter do  
  use Prometheus.Metric

  @counter name: :myapp_command_total, help: "Command Count", labels: [:command]

  def command(command_label) do
    Counter.inc(
      name: :myapp_command_total,
      labels: [command_label]
    )
  end
end  