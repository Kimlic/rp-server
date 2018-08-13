defmodule RpCore.Server.MediaSupervisor do
  @moduledoc false
  
  use Supervisor

  alias RpCore.Server.MediaServer

  ##### Public #####

  def start_link(args), do: Supervisor.start_link(__MODULE__, args, name: __MODULE__)

  def start_child([document: _, session_id: session_id] = args) do
    IO.inspect "START MEDIA CHILD ARGS: #{inspect args}"
    Supervisor.start_child(__MODULE__, [args])
  end

  ##### Private #####

  @impl true
  def init(args) do
    IO.inspect "MEDIA SUP ARGS: #{inspect args}"

    children = [
      worker(MediaServer, [args], restart: :temporary)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end
end