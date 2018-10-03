defmodule RpHttp.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      :hackney_pool.child_spec(:ap_pool, timeout: 30_000, max_connections: 100),
      :hackney_pool.child_spec(:kim_pool, timeout: 30_000, max_connections: 5)
    ]
    opts = [strategy: :one_for_one, name: RpHttp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
