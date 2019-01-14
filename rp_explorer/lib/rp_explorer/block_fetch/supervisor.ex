defmodule RpExplorer.BlockFetch.Supervisor do
  @moduledoc false

  use Supervisor

  alias RpExplorer.Lookup
  alias RpExplorer.BlockFetch.{
    Producer,
    ProducerConsumer,
    ConsumerSupervisor
  }

  ##### Public #####

  def start_link(args), do: Supervisor.start_link(__MODULE__, args, name: __MODULE__)

  ##### Private #####

  @impl true
  def init(_args) do
    produce = %{
      begin: 2600
    }
    filter = %{
      batch: 20,
      filter: "from",
      value: account_address()
    }
    request = %{
      batch: 20,
      limit: Lookup.blocks_count()
    }

    children = [
      worker(Producer, [produce]),
      worker(ProducerConsumer, [filter]),
      supervisor(ConsumerSupervisor, [request])
    ]
    supervise(children, strategy: :rest_for_one)
  end

  ##### Private #####

  @spec account_address :: binary
  defp account_address, do: env(:account_address)
  
  @spec env(binary) :: binary
  defp env(param), do: Application.get_env(:rp_explorer, param)
end