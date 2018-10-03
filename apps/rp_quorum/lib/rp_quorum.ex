defmodule RpQuorum do
  @moduledoc false
  
  use RpQuorum.Contract

  @unverified "0x0000000000000000000000000000000000000000000000000000000000000000"
  @verified "0x0000000000000000000000000000000000000000000000000000000000000001"

  ##### Public #####

  @spec get_provisioning_contract_factory(binary) :: binary
  def get_provisioning_contract_factory(contract_address), do: KimlicContractsContext.get_provisioning_contract_factory(contract_address)

  @spec create_provisioning_contract(binary, binary, binary, binary) :: binary
  def create_provisioning_contract(contract_address, account_address, document_type, tag) do
    contract_address
    |> ProvisioningContractFactory.create_provisioning_contract(account_address, document_type, tag)
  end

  @spec get_provisioning_contract(binary, binary) :: binary
  def get_provisioning_contract(contract_address, tag) do
    contract_address
    |> ProvisioningContractFactory.get_provisioning_contract(tag)
  end

  def is_verification_finished(contract_address) do
    res = contract_address
    |> ProvisioningContract.is_verification_finished

    case res do
      {:ok, @verified} -> {:ok, :verified}
      {:ok, @unverified} -> {:ok, :unverified}
    end
  end

  def finalize_provisioning(contract_address), do: ProvisioningContract.finalize_provisioning(contract_address)

  def get_verification_info(contract_address), do: ProvisioningContract.get_data(contract_address)

  def tokens_unlock_at(contract_address), do: ProvisioningContract.tokens_unlock_at(contract_address)

  def withdraw(contract_address), do: ProvisioningContract.withdraw(contract_address)

  @spec get_verification_contract_factory(binary) :: binary
  def get_verification_contract_factory(contract_address), do: KimlicContractsContext.get_verification_contract_factory(contract_address)

  def get_verification_contract(contract_address, session_tag) do
    contract_address
    |> VerificationContractFactory.get_verification_contract(session_tag)
  end

  def create_base_verification_contract(contract_address, user_address, attestator_address, doc_type, tag) do
    contract_address
    |> VerificationContractFactory.create_base_verification_contract(user_address, attestator_address, doc_type, tag)
  end
end
