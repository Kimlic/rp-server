defmodule RpQuorum.Contract.ProvisioningContract do
  @moduledoc false

  use RpQuorum.Contract

  alias RpQuorum.ABI.TypeDecoder

  @abi_file "provisioning_contract.json"
  @is_verified "isVerificationFinished"
  @finalize "finalizeProvisioning"
  @get_provisioning "getData"
  @withdraw "withdraw"
  @unlock_time "tokensUnlockAt"
  @addr_prefix "0x"

  # enum Status { None, Created, Verified, Unverified, Canceled }
  # @status_new "NEW"
  # @status_pending "PENDING"
  # @status_passed "PASSED"
  # @status_failed "FAILED"
  # @status_resubmission_requested "RESUBMISSION_REQUESTED"

  ##### Public #####

  @spec abi_file :: binary
  def abi_file, do: @abi_file

  @spec is_verification_finished(binary) :: {:ok, binary} | {:error, binary}
  def is_verification_finished(contract_address) do
    contract_address 
    |> ContractServer.call(ProvisioningContract, @is_verified)
  end

  @spec finalize_provisioning(binary) :: {:ok, binary, binary} | {:error, binary, map}
  def finalize_provisioning(contract_address) do
    contract_address
    |> ContractServer.transaction(ProvisioningContract, @finalize, {})
    |> case do
      {:ok, tx_hash} -> {:ok, @finalize, tx_hash}
      {:error, tx_receipt} -> {:error, @finalize, tx_receipt}
    end
  end

  @spec get_data(binary) :: {:ok, map}
  def get_data(contract_address) do
    types = [{:tuple, [:string, {:uint, 256}, :address, {:uint, 256}]}]

    {document, status, addr, verified_on} = contract_address 
    |> ContractServer.call(ProvisioningContract, @get_provisioning)
    |> decode(types)

    verification_contract_address = @addr_prefix <> Base.encode16(addr, case: :lower)
    data = %{
      document: document, 
      status: status, 
      verification_contract_address: verification_contract_address, 
      verified_on: verified_on
    }

    {:ok, data}
  end

  @spec tokens_unlock_at(binary) :: {:ok, number}
  def tokens_unlock_at(contract_address) do
    contract_address 
    |> ContractServer.call(ProvisioningContract, @unlock_time)
  end

  @spec withdraw(binary) :: {:ok, binary, binary} | {:error, binary, map}
  def withdraw(contract_address) do
    response = ContractServer.transaction(contract_address, ProvisioningContract, @withdraw, {})

    case response do
      {:ok, tx_hash} -> {:ok, @withdraw, tx_hash}
      {:error, tx_receipt} -> {:error, @withdraw, tx_receipt}
    end
  end

  ##### Private #####

  defp decode({:ok, @addr_prefix <> data}, types) do
    data
    |> Base.decode16!(case: :lower)
    |> TypeDecoder.decode_raw(types)
    |> Enum.at(0)
  end

  # @spec status(atom) :: binary
  # def status(:new), do: @status_new
  # def status(:pending), do: @status_pending
  # def status(:passed), do: @status_passed
  # def status(:failed), do: @status_failed
  # def status(:resubmission_requested), do: @status_resubmission_requested
end
