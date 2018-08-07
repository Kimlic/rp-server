defmodule RpQuorum.Contract.ProvisioningContractFactory do
  @moduledoc false

  use RpQuorum.Contract

  ##### Public #####

  @spec abi_file() :: binary
  def abi_file, do: "provisioning_contract_factory.json"

  @spec create_provisioning_contract(binary, binary, binary, binary) :: binary
  def create_provisioning_contract(contract_address, account_address, document_type, session_tag) do
    params = {account_address, document_type, session_tag}
    response = ContractServer.transaction(contract_address, ProvisioningContractFactory, "createProvisioningContract", params)

    case response do
      {:ok, tx_hash} -> {:ok, "createProvisioningContract", tx_hash}
      {:error, tx_receipt} -> {:error, "createProvisioningContract", tx_receipt}
    end
  end

  @spec get_provisioning_contract(binary, binary) :: binary
  def get_provisioning_contract(contract_address, tag) do
    contract_address
    |> get_address("getProvisioningContract", {tag})
  end

  # ##### Private #####

  @spec get_address(binary, binary) :: binary
  defp get_address(contract_address, method, params \\ {}) do
    address = contract_address 
    |> ContractServer.call(ProvisioningContractFactory, method, params)
    |> Kernel.elem(1)
    |> String.slice(-40..-1)
    |> add_prefix("0x")
    
    {:ok, address}
  end

  @spec add_prefix(binary, binary) :: binary
  defp add_prefix(string, prefix), do: prefix <> string
end
