defmodule RpQuorum.Contract.VerificationContractFactory do
  @moduledoc false

  use RpQuorum.Contract

  ##### Public #####

  @spec abi_file() :: binary
  def abi_file, do: "verification_contract_factory.json"

  @spec create_base_verification_contract(binary, binary, binary, binary, binary) :: {:ok, binary, binary} | {:error, binary, map}
  def create_base_verification_contract(contract_address, user_address, attestator_address, doc_type, session_tag) do
    params = {user_address, attestator_address, session_tag, doc_type}
    response = ContractServer.transaction(contract_address, VerificationContractFactory, "createBaseVerificationContract", params)

    case response do
      {:ok, tx_hash} -> {:ok, "createBaseVerificationContract", tx_hash}
      {:error, tx_receipt} -> {:error, "createBaseVerificationContract", tx_receipt}
    end
  end
end
