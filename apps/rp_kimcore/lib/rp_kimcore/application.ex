defmodule RpKimcore.Application do
  @moduledoc false

  use Application

  alias RpKimcore.Server.ConfigServer

  ##### Public #####

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(ConfigServer, [[]], restart: :permanent)
    ]
    opts = [strategy: :one_for_one, name: RpKimcore.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
