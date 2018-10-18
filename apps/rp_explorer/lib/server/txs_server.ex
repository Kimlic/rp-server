defmodule RpExplorer.TxsServer do
  @moduledoc false

  use GenServer

  @err_provisioning_address "Unable to fetch provisioning factory address"

  ##### Public #####

  def start_link(args), do: GenServer.start_link(__MODULE__, args, name: __MODULE__)

  @spec put_tx(binary) :: :ok
  def put_tx(tx), do: GenServer.cast(__MODULE__, {:put_tx, tx})

  @spec address_provisioning :: {:ok, binary}
  def address_provisioning, do: GenServer.call(__MODULE__, {:address_provisioning, nil})

  @spec address_verification :: {:ok, binary}
  def address_verification, do: GenServer.call(__MODULE__, {:address_verification, nil})

  ##### Callbacks #####

  @impl true
  def init(_args) do
    txs_provisioning = :ets.new(:txs_provisioning, [:named_table, read_concurrency: true])
    txs_verification = :ets.new(:txs_verification, [:named_table, read_concurrency: true])

    state = %{
      txs_provisioning: txs_provisioning, 
      txs_verification: txs_verification,
      address_provisioning: nil,
      address_verification: nil
    }

    {:ok, state, {:continue, :fetch_addresses}}
  end

  @impl true
  def handle_cast({:put_tx, tx}, state) do
    IO.puts "PUT TX: #{inspect tx}"
    {:noreply, state}
  end

  @impl true
  def handle_continue(:fetch_addresses, state) do
    with {:ok, config} <- RpKimcore.config(),
    context <- config.context_contract,
    {:ok, address_provisioning} <- RpQuorum.get_provisioning_contract_factory(context),
    {:ok, address_verification} <- RpQuorum.get_verification_contract_factory(context) do
      new_state = %{state | address_provisioning: address_provisioning, address_verification: address_verification}

      {:noreply, new_state}
    else
      _ -> {:stop, @err_provisioning_address}
    end
  end

  @impl true
  def handle_call(:address_provisioning, _, %{address_provisioning: address} = state), do: {:reply, {:ok, address}, state}
  def handle_call(:address_verification, _, %{address_verification: address} = state), do: {:reply, {:ok, address}, state}
end