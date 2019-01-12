defmodule RpKimcore.Application do
  @moduledoc false

  use Application

  alias RpKimcore.Server.ConfigServer

  def start(_type, _args) do
    :prometheus_httpd.start()
    
    children = [
      {ConfigServer, []}
    ]
    opts = [strategy: :one_for_one, name: RpKimcore.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
