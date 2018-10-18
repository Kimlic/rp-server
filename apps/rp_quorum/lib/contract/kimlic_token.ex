defmodule RpQuorum.Contract.KimlicToken do
  @moduledoc false

  use RpQuorum.Contract

  alias RpQuorum.ABI.TypeDecoder

  @abi_file "kimlic_token.json"
  @balance "balanceOf"
  @addr_prefix "0x"

  ##### Public #####

  @spec abi_file :: binary
  def abi_file, do: @abi_file

  @spec balance_of(binary, binary) :: {:ok, number}
  def balance_of(contract_address, account_address) do
    contract_address 
    |> get_value(@balance, {account_address})
  end

  ##### Private #####

  @spec get_value(binary, binary, tuple) :: {:ok, number}
  defp get_value(contract_address, method, params) do
    types = [{:uint, 256}]

    value = contract_address 
    |> ContractServer.call(__MODULE__, method, params)
    |> Kernel.elem(1)
    |> decode(types)
    
    {:ok, round(value / 1_000_000_000_000_00)}
  end

  @spec decode(binary, list) :: binary
  defp decode(@addr_prefix <> data, types) do
    data
    |> Base.decode16!(case: :lower)
    |> TypeDecoder.decode_raw(types)
    |> Enum.at(0)
  end
end
