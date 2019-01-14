defmodule RpExplorer.Lookup do

  @addr_prefix "0x"

  ##### Public #####

  @spec find_blocks(number, number) :: list(map)
  def find_blocks(from, to) do
    fetch_blocks(from, to)
    |> Stream.filter(fn block -> !is_nil(block) end)
    |> Enum.to_list
  end

  @spec blocks_count :: number
  def blocks_count do
    Ethereumex.HttpClient.eth_block_number
    |> Kernel.elem(1)
    |> int_from_hex
  end

  @spec filter_blocks(list(map), binary, binary) :: list(map)
  def filter_blocks(blocks, param, from_address) do
    blocks
    |> Stream.filter(fn block -> 
      filter_block_by_param(block, param, from_address)
    end)
    |> Enum.to_list
  end

  ##### Private #####

  @spec int_from_hex(binary) :: number
  defp int_from_hex(@addr_prefix <> data) do
    data
    |> Integer.parse(16)
    |> Kernel.elem(0)
  end

  @spec hex_from_int(number) :: binary
  defp hex_from_int(num), do: @addr_prefix <> Integer.to_string(num, 16)

  @spec fetch_block(number) :: map
  defp fetch_block(num) do
    hex_from_int(num)
    |> Ethereumex.HttpClient.eth_get_block_by_number(true)
    |> Kernel.elem(1)
  end

  @spec fetch_blocks(number, number) :: list(map)
  defp fetch_blocks(block_from, block_to) do
    for num <- block_from..block_to, do: fetch_block(num)
  end

  @spec filter_block_by_param(map, binary, binary) :: boolean
  defp filter_block_by_param(block, param, from_address) do
    block
    |> Map.fetch!("transactions")
    |> Stream.filter(fn tx -> 
      filter_tx_by_from(tx, param, from_address)
    end)
    |> Enum.to_list
    |> Kernel.length
    |> Kernel.>(0)
  end

  @spec filter_tx_by_from(map, binary, binary) :: boolean
  defp filter_tx_by_from(tx, param, from) do
    tx
    |> Map.fetch!(param)
    |> Kernel.==(from)
  end
end