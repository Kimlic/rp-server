defmodule RpQuorum.Contract.ProvisioningContract do
  @moduledoc false

  use RpQuorum.Contract

  ##### Public #####

  @spec abi_file() :: binary
  def abi_file, do: "provisioning_contract.json"

  @spec is_verification_finished(binary) :: {:ok, binary} | {:error, binary}
  def is_verification_finished(contract_address) do
    contract_address 
    |> ContractServer.call(ProvisioningContract, "isVerificationFinished")
  end
end
