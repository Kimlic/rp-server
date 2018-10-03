defmodule RpHttp.Application do
  use Application

  def start(_type, _args) do
    children = [
      :hackney_pool.child_spec(:ap_server, timeout: 30_000, max_connections: 100)
    ]
    opts = [strategy: :one_for_one, name: RpHttp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
