defmodule RpCore.Server.ServerSupervisor do
  @moduledoc false

  use Supervisor

  alias RpCore.Server.{MediaRegistry, MediaSupervisor}

  ##### Public #####

  def start_link(args), do: Supervisor.start_link(__MODULE__, args, name: __MODULE__)

  ##### Private #####

  @impl true
  def init(_args) do
    children = [
      supervisor(MediaSupervisor, [[]], restart: :permanent),
      worker(MediaRegistry, [[]], restart: :permanent)
    ]
    supervise(children, strategy: :rest_for_one)
  end
end