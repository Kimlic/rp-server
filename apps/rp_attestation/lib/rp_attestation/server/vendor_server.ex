defmodule RpAttestation.Server.VendorServer do
  use GenServer

  alias RpAttestation.DataProvider

  @poll_delay 24 * 60 * 60 * 1_000
  @reload_delay 60 * 1_000

  ##### Public #####

  @spec start_link(list) :: {:ok, pid} | {:error, binary}
  def start_link(_), do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)

  @spec vendors() :: {:ok, map}
  def vendors, do: GenServer.call(__MODULE__, :vendors)

  ##### Callbacks #####

  @impl true
  def init(_) do
    self() 
    |> send(:vendors)

    {:ok, nil}
  end

  @impl true
  def handle_call(:vendors, _, %{vendors: vendors} = state), do: {:reply, {:ok, vendors}, state}
  def handle_call(_, _, state), do: {:noreply, state}

  @impl true
  def handle_info(:vendors, state) do
    with {:ok, vendors} <- DataProvider.vendors() do
      case vendors do
        :econnrefused -> 
          schedule_fast_reload()
          {:noreply, state}

        vendors -> 
          schedule_reload()
          {:noreply, %{vendors: vendors}}
      end
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
    |> Process.send_after(:vendors, @poll_delay)
  end

  @spec schedule_fast_reload() :: reference()
  defp schedule_fast_reload do
    self()
    |> Process.send_after(:vendors, @reload_delay)
  end
end