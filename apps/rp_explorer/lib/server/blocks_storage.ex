defmodule RpExplorer.BlocksStorage do

  alias RpExplorer.TxsServer

  ##### Public #####

  def start_link(event) do
    Task.start_link fn -> 
      {:ok, provisioning_factory} = TxsServer.address_provisioning()
      {:ok, verification_factory} = TxsServer.address_verification()

      block_num = event["number"]
      |> int_from_hex

      txs_stream = event["transactions"]
      |> Stream.map(fn tx -> 
        %{"to" => to, "blockNumber" => block_hex, "hash" => hash} = tx

        block_number = block_hex
        |> int_from_hex

        %{to: to, block_number: block_number, hash: hash}
      end) 

      provisioning_txs = txs_stream
      |> Stream.filter(fn tx -> 
        tx
        |> Map.fetch(:to)
        |> Kernel.elem(1)
        |> Kernel.==(provisioning_factory)
      end)
      |> Enum.to_list

      verification_txs = txs_stream
      |> Stream.filter(fn tx -> 
        tx
        |> Map.fetch(:to)
        |> Kernel.elem(1)
        |> Kernel.==(verification_factory)
      end)
      |> Enum.to_list


      IO.puts "Process block: #{inspect {self(), block_num}}"
      IO.puts "Provisioning txs: #{inspect provisioning_txs}"
      IO.puts "Verification txs: #{inspect verification_txs}"
      IO.puts "----------------------------------------------------------"
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