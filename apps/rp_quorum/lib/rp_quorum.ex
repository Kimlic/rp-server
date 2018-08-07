defmodule RpQuorum do
  @moduledoc false
  
  use RpQuorum.Contract

  ##### Public #####
  
  # def create_account do
  #   {:ok, address} = ContractServer.create_unlocked_account("password")
  #   address
  # end

  @spec get_provisioning_contract_factory(binary) :: binary
  def get_provisioning_contract_factory(contract_address) do
    res = contract_address
    |> KimlicContractsContext.get_provisioning_contract_factory

    IO.inspect "get_provisioning_contract_factory: #{inspect res}"
    res
  end
  
  @spec create_provisioning_contract(binary, binary, binary, binary) :: binary
  def create_provisioning_contract(contract_address, account_address, document_type, tag) do
    res = contract_address
    |> ProvisioningContractFactory.create_provisioning_contract(account_address, document_type, tag)

    IO.inspect "create_provisioning_contract: #{inspect res}"
    res
  end

  @spec get_provisioning_contract(binary, binary) :: binary
  def get_provisioning_contract(contract_address, tag) do
    res = contract_address
    |> ProvisioningContractFactory.get_provisioning_contract(tag)

    IO.inspect "get_provisioning_contract: #{inspect res}"
    res
  end

  def is_verification_finished(contract_address) do
    res = contract_address
    |> ProvisioningContract.is_verification_finished

    IO.inspect "is_verification_finished: #{inspect res}"
    res
  end

  @spec get_verification_contract_factory(binary) :: binary
  def get_verification_contract_factory(contract_address) do
    res = contract_address
    |> KimlicContractsContext.get_verification_contract_factory

    IO.inspect "get_verification_contract_factory: #{inspect res}"
    res
  end

  def create_base_verification_contract(contract_address, user_address, attestator_address, doc_type, tag) do
    res = contract_address
    |> VerificationContractFactory.create_base_verification_contract(user_address, attestator_address, doc_type, tag)

    IO.inspect "create_base_verification_contract: #{inspect res}"
    res
  end
end
