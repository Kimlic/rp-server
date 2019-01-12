defmodule RpKimcore.Server.ConfigServer do
  use GenServer, restart: :permanent

  alias RpKimcore.DataProvider
  alias RpKimcore.Schema.Config

  @poll_delay 24 * 60 * 60 * 1_000

  # Public

  @spec start_link(list) :: {:ok, pid} | {:error, binary}
  def start_link(_), do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)

  @spec config :: {:ok, Config.t}
  def config, do: GenServer.call(__MODULE__, :config)

  # Callbacks

  @impl true
  def init(_), do: {:ok, %{config: nil}, {:continue, :config}}

  @impl true
  def handle_call(:config, _, %{config: config} = state) do
    {:reply, {:ok, config}, state}
  end

  @impl true
  def handle_continue(:config, _state) do
    with {:ok, %Config{} = config} <- DataProvider.config() do
      schedule_reload()
      {:noreply, %{config: config}}
    else
      {:error, :closed} ->
        schedule_reload() 
        {:noreply, %{config: nil}}
        
      {:error, :econnrefused} -> 
        schedule_reload()
        {:noreply, %{config: nil}}

      {:error, reason} -> {:stop, reason}
    end
  end

  # Private

  @spec schedule_reload :: reference
  defp schedule_reload, do: Process.send_after(self(), :config, @poll_delay)
end