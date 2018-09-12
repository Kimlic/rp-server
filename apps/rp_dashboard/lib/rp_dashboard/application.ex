defmodule RpDashboard.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(RpDashboardWeb.Endpoint, [])
    ]

    opts = [strategy: :one_for_one, name: RpDashboard.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    RpDashboardWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
