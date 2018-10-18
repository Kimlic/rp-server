defmodule RpQuorum.Contract.KimlicContractsContext do
  @moduledoc false

  use RpQuorum.Contract

  @abi_file "kimlic_contracts_context.json"
  @account_adapter "getAccountStorageAdapter"
  @provisioning_factory "getProvisioningContractFactory"
  @verification_factory "getVerificationContractFactory"
  @addr_prefix "0x"

  ##### Public #####

  @spec abi_file :: binary
  def abi_file, do: @abi_file

  @spec get_account_storage_adapter(binary) :: binary
  def get_account_storage_adapter(contract_address) do
    get_address(contract_address, @account_adapter)
  end

  @spec get_provisioning_contract_factory(binary) :: binary
  def get_provisioning_contract_factory(contract_address) do
    get_address(contract_address, @provisioning_factory)
  end

  @spec get_verification_contract_factory(binary) :: binary
  def get_verification_contract_factory(contract_address) do
    get_address(contract_address, @verification_factory)
  end

  ##### Private #####

  @spec get_address(binary, binary) :: {:ok, binary}
  defp get_address(contract_address, type) do
    address = contract_address 
    |> ContractServer.call(KimlicContractsContext, type)
    |> Kernel.elem(1)
    |> String.slice(-40..-1)
    |> add_prefix(@addr_prefix)
    
    {:ok, address}
  end

  @spec add_prefix(binary, binary) :: binary
  defp add_prefix(string, prefix), do: prefix <> string
end
