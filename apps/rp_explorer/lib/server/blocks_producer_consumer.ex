defmodule RpExplorer.BlocksProducerConsumer do
  @moduledoc false

  use GenStage

  alias RpExplorer.{BlocksProducer, Lookup}

  ##### Public #####

  def start_link(args), do: GenStage.start_link(__MODULE__, args, name: __MODULE__)

  ##### Callbacks #####

  @impl true
  def init(%{batch: batch} = args) do
    attrs = [
      min_demand: round(batch / 2), 
      max_demand: batch
    ]
    {:producer_consumer, args, subscribe_to: [{BlocksProducer, attrs}]}
  end

  @impl true
  def handle_events(events, _, %{filter: filter, value: value} = state) do
    new_events = events
    |> Lookup.filter_blocks(filter, value)

    {:noreply, new_events, state}
  end
end