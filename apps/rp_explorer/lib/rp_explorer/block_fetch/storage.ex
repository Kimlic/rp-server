defmodule RpExplorer.BlockFetch.Storage do

  alias RpExplorer.Server.TxsServer

  ##### Public #####

  def start_link(event) do
    Task.start_link fn -> 
      {:ok, provisioning_factory} = TxsServer.address_provisioning()
      {:ok, verification_factory} = TxsServer.address_verification()

      txs_stream = event["transactions"]
      |> Stream.map(fn tx -> 
        %{"to" => to, "blockNumber" => block_hex, "hash" => hash} = tx

        block_number = block_hex
        |> int_from_hex

        %{to: to, block_number: block_number, hash: hash}
      end) 

      txs_stream
      # |> Stream.filter(fn tx -> 
      #   tx
      #   |> Map.fetch(:to)
      #   |> Kernel.elem(1)
      #   |> Kernel.==(provisioning_factory)
      # end)
      |> Enum.to_list
      |> TxsServer.put_txs

      # txs_stream
      # |> Stream.filter(fn tx -> 
      #   tx
      #   |> Map.fetch(:to)
      #   |> Kernel.elem(1)
      #   |> Kernel.==(verification_factory)
      # end)
      # |> Enum.to_list
      # |> TxsServer.put_txs
    end
  end

  ##### Private #####

  @spec int_from_hex(binary) :: number
  defp int_from_hex("0x" <> data) do
    data
    |> Integer.parse(16)
    |> Kernel.elem(0)
  end
end