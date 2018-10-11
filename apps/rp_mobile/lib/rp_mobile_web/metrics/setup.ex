defmodule RpMobileWeb.Metrics.Setup do  
  def setup do
    RpMobileWeb.Metrics.MetricsExporter.setup()
  end
end  