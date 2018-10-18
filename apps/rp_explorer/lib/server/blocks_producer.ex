defmodule RpExplorer.BlocksProducer do
  @moduledoc false

  use GenStage

  alias RpExplorer.Lookup

  ##### Public #####

  def start_link(args), do: GenStage.start_link(__MODULE__, args, name: __MODULE__)

  ##### Callbacks #####

  @impl true
  def init(%{begin: begin}), do: {:producer, %{current: begin}}

  @impl true
  def handle_demand(demand, %{current: current} = state) when demand > 0 do
    next_current = current + demand - 1
    blocks = Lookup.find_blocks(current, next_current)

    {:noreply, blocks, %{state | current: next_current}}
  end
end