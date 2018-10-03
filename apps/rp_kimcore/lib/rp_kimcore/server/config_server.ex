defmodule RpKimcore.Server.ConfigServer do
  use GenServer

  alias RpKimcore.DataProvider
  alias RpKimcore.Schemes.Config

  @poll_delay 24 * 60 * 60 * 1_000

  ##### Public #####

  @spec start_link(list) :: {:ok, pid} | {:error, binary}
  def start_link(_), do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)

  @spec config() :: {:ok, Config.t()}
  def config, do: GenServer.call(__MODULE__, :config)

  ##### Callbacks #####

  @impl true
  def init(_) do
    self() 
    |> send(:config)

    {:ok, nil}
  end

  @impl true
  def handle_call(:config, _, %{config: config} = state), do: {:reply, {:ok, config}, state}
  def handle_call(_, _, state), do: {:noreply, state}

  @impl true
  def handle_info(:config, state) do
    with {:ok, %Config{} = config} <- DataProvider.config() do
      schedule_reload()
      {:noreply, %{config: config}}
    else
      {:error, :closed} -> 
        schedule_reload()
        {:noreply, state}

      {:error, reason} -> {:stop, reason}
    end
  end
  def handle_info(_, state), do: {:noreply, state}

  ##### Private #####

  @spec schedule_reload() :: reference()
  defp schedule_reload do
    self()
    |> Process.send_after(:config, @poll_delay)
  end
end