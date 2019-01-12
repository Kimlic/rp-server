defmodule RpCore.Server.DocumentServer do
  @moduledoc false

  use GenServer

  alias RpCore.Model.Document

  ##### Public #####

  def start_link(args), do: GenServer.start_link(__MODULE__, args, name: __MODULE__)

  ##### Callback #####

  @impl true
  def init(_args) do
    :ets.new(:documents, [:named_table, read_concurrency: true])

    {:ok, nil, {:continue, :fetch_documents}}
  end

  @impl true
  def handle_continue(:fetch_documents, state) do
    Document.session_tags
    |> Kernel.elem(1)
    # |> Enum.map(fn tag -> 
    #   Rp.Quorum
    # end)
    |> Enum.each(&:ets.insert(:documents, {&1}))

    {:noreply, state}
  end
end