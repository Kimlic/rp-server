defmodule RpExplorer.Application do
  @moduledoc false

  use Application

  # alias RpExplorer.{
  #   BlocksProducer, 
  #   BlocksProducerConsumer, 
  #   BlocksConsumerSupervisor,
  #   TxsServer
  # }
  
  ##### Public #####

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # produce = %{
    #   begin: 2600
    # }
    # filter = %{
    #   batch: 20,
    #   filter: "from",
    #   value: account_address()
    # }
    # request = %{
    #   batch: 20,
    #   limit: RpExplorer.Lookup.blocks_count()
    # }

    children = [
      # worker(TxsServer, [[]], restart: :permanent),
      # worker(BlocksProducer, [produce]),
      # worker(BlocksProducerConsumer, [filter]),
      # supervisor(BlocksConsumerSupervisor, [request])
    ]
    opts = [strategy: :one_for_one, name: RpExplorer.Supervisor]
    Supervisor.start_link(children, opts)
  end
  
  ##### Private #####

  # @spec account_address :: binary
  # defp account_address, do: env(:account_address)
  
  # @spec env(binary) :: binary
  # defp env(param), do: Application.get_env(:rp_explorer, param)
end
