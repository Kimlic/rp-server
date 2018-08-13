defmodule RpCore.Application do
  use Application

  alias RpCore.Repo
  alias RpCore.Server.ServerSupervisor

  @spec start(Application.start_type(), list) :: Supervisor.on_start()
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Repo, []),
      supervisor(ServerSupervisor, [[]])
    ]
    opts = [strategy: :one_for_one, name: RpCore.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
