defmodule RpUaf.Application do
  use Application

  @spec start(Application.start_type(), list) :: Supervisor.on_start()
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(RpUaf.Repo, []),
    ]
    opts = [strategy: :one_for_one, name: RpUaf.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
 