defmodule RpExplorer.BlocksConsumerSupervisor do
  @moduledoc false

  use ConsumerSupervisor

  alias RpExplorer.{BlocksStorage, BlocksProducerConsumer}

  ##### Public #####

  def start_link(%{batch: batch, limit: _limit}) do
    children = [
      worker(BlocksStorage, [], restart: :temporary)
    ]
    opts = [
      strategy: :one_for_one, 
      subscribe_to: [{BlocksProducerConsumer, max_demand: batch}], 
      name: __MODULE__
    ]
    ConsumerSupervisor.start_link(children, opts)
  end

  ##### Callbacks #####

  @impl true
  def init(args), do: {:consumer, args}
end