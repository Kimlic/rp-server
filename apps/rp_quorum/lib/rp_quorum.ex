defmodule RpQuorum do
  @moduledoc false
  
  use RpQuorum.Contract

  @unverified "0x0000000000000000000000000000000000000000000000000000000000000000"
  @verified "0x0000000000000000000000000000000000000000000000000000000000000001"

  ##### Public #####

  @spec create_provisioning(binary, binary, binary, binary) :: binary
  def create_provisioning(context_contract, user_address, doc_type, session_tag) do
    with {:ok, provisioning_factory} <- KimlicContractsContext.get_provisioning_contract_factory(context_contract),
    {:ok, _method, _tx_hash} <- ProvisioningContractFactory.create_provisioning_contract(provisioning_factory, user_address, doc_type, session_tag),
    {:ok, provisioning_contract} <- ProvisioningContractFactory.get_provisioning_contract(provisioning_factory, session_tag) do
      provisioning_contract
    end
  end

  @spec create_verification(binary, binary, binary, binary, binary) :: {:ok, binary}
  def create_verification(context_contract, user_address, ap_address, doc_type, session_tag) do
    with {:ok, verification_factory} <- KimlicContractsContext.get_verification_contract_factory(context_contract),
    {:ok, _method, _tx_hash} <- VerificationContractFactory.create_base_verification_contract(verification_factory, user_address, ap_address, doc_type, session_tag) do
      VerificationContractFactory.get_verification_contract(verification_factory, session_tag)
    end
  end

  @spec verification_decision(binary) :: {:ok, :verified | :unverified, binary}
  def verification_decision(provisioning_contract) do
    with {:ok, :verified} <- is_verification_finished(provisioning_contract),
    {:ok, "finalizeProvisioning", _} = ProvisioningContract.finalize_provisioning(provisioning_contract),
    {:ok, _} <- ProvisioningContract.get_data(provisioning_contract) do
      {:ok, :verified, provisioning_contract}
    else
      {:ok, :unverified} -> {:ok, :unverified, provisioning_contract}
    end
  end

  @spec revoke_provisioning(binary) :: {:ok | :error, binary, binary | map}
  def revoke_provisioning(provisioning_contract) do
    ProvisioningContract.tokens_unlock_at(provisioning_contract)
    ProvisioningContract.withdraw(provisioning_contract)
  end

  ##### Private #####

  @spec is_verification_finished(binary) :: {:ok, :verified | :unverified}
  defp is_verification_finished(contract_address) do
    contract_address
    |> ProvisioningContract.is_verification_finished
    |> case do
      {:ok, @verified} -> {:ok, :verified}
      {:ok, @unverified} -> {:ok, :unverified}
    end
  end
end
