defmodule RpMobile.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(RpMobileWeb.Endpoint, []),
    ]
    opts = [strategy: :one_for_one, name: RpMobile.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    RpMobileWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
