defmodule RpExplorer.Application do
  @moduledoc false

  use Application

  alias RpExplorer.Server.TxsServer
  alias RpExplorer.BlockFetch
  
  ##### Public #####

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(TxsServer, [[]], restart: :permanent),
      supervisor(BlockFetch.Supervisor, [[]])
    ]
    opts = [strategy: :one_for_one, name: RpExplorer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
