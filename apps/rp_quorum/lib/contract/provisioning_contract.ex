defmodule RpQuorum.Contract.ProvisioningContract do
  @moduledoc false

  use RpQuorum.Contract

  alias RpQuorum.ABI.TypeDecoder

  # enum Status { None, Created, Verified, Unverified, Canceled }
  # @status_new "NEW"
  # @status_pending "PENDING"
  # @status_passed "PASSED"
  # @status_failed "FAILED"
  # @status_resubmission_requested "RESUBMISSION_REQUESTED"

  ##### Public #####

  @spec abi_file() :: binary
  def abi_file, do: "provisioning_contract.json"

  @spec is_verification_finished(binary) :: {:ok, binary} | {:error, binary}
  def is_verification_finished(contract_address) do
    res = contract_address 
    |> ContractServer.call(ProvisioningContract, "isVerificationFinished")
    IO.puts "isVerificationFinished: #{inspect res}"
    res
  end

  def finalize_provisioning(contract_address) do
    response = ContractServer.transaction(contract_address, ProvisioningContract, "finalizeProvisioning", {})

    case response do
      {:ok, tx_hash} -> {:ok, "finalizeProvisioning", tx_hash}
      {:error, tx_receipt} -> {:error, "finalizeProvisioning", tx_receipt}
    end
  end

  def get_data(contract_address) do
    types = [{:tuple, [:string, {:uint, 256}, :address, {:uint, 256}]}]

    {document, status, addr, verified_on} = contract_address 
    |> ContractServer.call(ProvisioningContract, "getData")
    |> decode(types)

    verification_contract_address = "0x" <> Base.encode16(addr, case: :lower)
    data = %{
      document: document, 
      status: status, 
      verification_contract_address: verification_contract_address, 
      verified_on: verified_on
    }

    {:ok, data}
  end

  def tokens_unlock_at(contract_address) do
    contract_address 
    |> ContractServer.call(ProvisioningContract, "tokensUnlockAt")
  end

  def withdraw(contract_address) do
    response = ContractServer.transaction(contract_address, ProvisioningContract, "withdraw", {})

    case response do
      {:ok, tx_hash} -> {:ok, "withdraw", tx_hash}
      {:error, tx_receipt} -> {:error, "withdraw", tx_receipt}
    end
  end

  ##### Private #####

  defp decode({:ok, "0x" <> data}, types) do
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
