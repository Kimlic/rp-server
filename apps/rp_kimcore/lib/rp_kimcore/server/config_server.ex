defmodule RpKimcore.Server.ConfigServer do
  use GenServer

  alias RpKimcore.DataProvider
  alias RpKimcore.Schemes.Config

  ##### Public #####

  @spec start_link(list) :: {:ok, pid} | {:error, binary}
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @spec config() :: {:ok, Config.t()}
  def config, do: GenServer.call(__MODULE__, :config)

  ##### Callbacks #####

  @impl true
  def init(_) do
    send(self(), :config)
    {:ok, nil}
  end

  @impl true
  def handle_call(:config, _, %{config: config} = state) do
    {:reply, {:ok, config}, state}
  end
  def handle_call(_, _, state), do: {:noreply, state}

  @impl true
  def handle_info(:config, _) do
    with {:ok, %Config{} = config} <- DataProvider.config() do
      {:noreply, %{config: config}}
    else
      {:error, reason} -> {:stop, reason}
    end
  end
  def handle_info(_, state), do: {:noreply, state}
end