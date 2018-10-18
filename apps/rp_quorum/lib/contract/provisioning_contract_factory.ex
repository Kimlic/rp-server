defmodule RpQuorum.Contract.ProvisioningContractFactory do
  @moduledoc false

  use RpQuorum.Contract

  @abi_file "provisioning_contract_factory.json"
  @createProvisioning "createProvisioningContract"
  @getProvisioning "getProvisioningContract"
  @addr_prefix "0x"

  ##### Public #####

  @spec abi_file() :: binary
  def abi_file, do: @abi_file

  @spec create_provisioning_contract(binary, binary, binary, binary) :: binary
  def create_provisioning_contract(contract_address, account_address, document_type, session_tag) do
    params = {account_address, document_type, session_tag}
    response = ContractServer.transaction(contract_address, ProvisioningContractFactory, @createProvisioning, params)

    case response do
      {:ok, tx_hash} -> {:ok, @createProvisioning, tx_hash}
      {:error, tx_receipt} -> {:error, @createProvisioning, tx_receipt}
    end
  end

  @spec get_provisioning_contract(binary, binary) :: binary
  def get_provisioning_contract(contract_address, tag) do
    get_address(contract_address, @getProvisioning, {tag})
  end

  # ##### Private #####

  @spec get_address(binary, binary, tuple) :: {:ok, binary}
  defp get_address(contract_address, method, params) do
    address = contract_address 
    |> ContractServer.call(ProvisioningContractFactory, method, params)
    |> Kernel.elem(1)
    |> String.slice(-40..-1)
    |> add_prefix(@addr_prefix)
    
    {:ok, address}
  end

  @spec add_prefix(binary, binary) :: binary
  defp add_prefix(string, prefix), do: prefix <> string
end
