defmodule RpExplorer.Server.TxsServer do
  @moduledoc false

  use GenServer

  @err_provisioning_address "Unable to fetch provisioning factory address"

  ##### Public #####

  def start_link(args), do: GenServer.start_link(__MODULE__, args, name: __MODULE__)

  @spec put_txs(list(map)) :: :ok
  def put_txs(txs), do: GenServer.cast(__MODULE__, {:put_txs, txs})

  @spec address_provisioning :: {:ok, binary}
  def address_provisioning, do: GenServer.call(__MODULE__, :provisioning)

  @spec address_verification :: {:ok, binary}
  def address_verification, do: GenServer.call(__MODULE__, :verification)

  ##### Callbacks #####

  @impl true
  def init(_args) do
    [:txs_provisioning, :txs_verification, :txs_incoming]
    |> Enum.each(&:ets.new(&1, [:named_table, read_concurrency: true]))

    state = %{
      provisioning: nil,
      verification: nil
    }

    {:ok, state, {:continue, :fetch_addresses}}
  end

  @impl true
  def handle_cast({:put_txs, []}, state), do: {:noreply, state}
  def handle_cast({:put_txs, [tx | txs]}, state) do
    insert_tx(tx, state)
    GenServer.cast(__MODULE__, {:put_txs, txs})

    {:noreply, state}
  end

  defp insert_tx(tx, state) do
    with %{to: to, from: from, hash: hash, block_number: block_number} <- tx,
    %{provisioning: provisioning, verification: verification} <- state,
    account <- account_address() do
      case to do
        ^provisioning -> :txs_provisioning
        ^verification -> :txs_verification
        ^account -> 
          IO.puts "TX: #{inspect tx}"
          :txs_incoming
        _ -> :invalid
      end
      |> case do
        :invalid -> :invalid
        table -> :ets.insert(table, {hash, block_number})
      end
    end
  end

  @impl true
  def handle_continue(:fetch_addresses, state) do
    with {:ok, config} <- RpKimcore.config(),
    context <- config.context_contract,
    {:ok, provisioning} <- RpQuorum.get_provisioning_contract_factory(context),
    {:ok, verification} <- RpQuorum.get_verification_contract_factory(context) do
      IO.puts "AAA: #{inspect provisioning}"
      IO.puts "BBB: #{inspect verification}"
      new_state = %{state | provisioning: provisioning, verification: verification}

      {:noreply, new_state}
    else
      _ -> {:stop, @err_provisioning_address}
    end
  end

  @impl true
  def handle_call(:provisioning, _, %{provisioning: address} = state), do: {:reply, {:ok, address}, state}
  def handle_call(:verification, _, %{verification: address} = state), do: {:reply, {:ok, address}, state}

  ##### Private #####

  @spec account_address :: binary
  defp account_address, do: env(:account_address)
  
  @spec env(binary) :: binary
  defp env(param), do: Application.get_env(:rp_explorer, param)
end