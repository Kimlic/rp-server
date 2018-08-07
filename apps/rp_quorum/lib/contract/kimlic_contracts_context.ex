defmodule RpQuorum.Contract.KimlicContractsContext do
  @moduledoc false

  use RpQuorum.Contract

  ##### Public #####

  @spec abi_file() :: binary
  def abi_file, do: "kimlic_contracts_context.json"

  @spec get_account_storage_adapter(binary) :: binary
  def get_account_storage_adapter(contract_address) do
    contract_address 
    |> get_address("getAccountStorageAdapter")
  end

  @spec get_provisioning_contract_factory(binary) :: binary
  def get_provisioning_contract_factory(contract_address) do
    contract_address 
    |> get_address("getProvisioningContractFactory")
  end

  @spec get_verification_contract_factory(binary) :: binary
  def get_verification_contract_factory(contract_address) do
    contract_address
    |> get_address("getVerificationContractFactory")
  end

  ##### Private #####

  @spec get_address(binary, binary) :: binary
  defp get_address(contract_address, type) do
    address = contract_address 
    |> ContractServer.call(KimlicContractsContext, type)
    |> Kernel.elem(1)
    |> String.slice(-40..-1)
    |> add_prefix("0x")
    
    {:ok, address}
  end

  @spec add_prefix(binary, binary) :: binary
  defp add_prefix(string, prefix), do: prefix <> string
end
