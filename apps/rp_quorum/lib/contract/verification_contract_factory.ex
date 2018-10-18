defmodule RpQuorum.Contract.VerificationContractFactory do
  @moduledoc false

  use RpQuorum.Contract

  @abi_file "verification_contract_factory.json"
  @unverified "0x0000000000000000000000000000000000000000000000000000000000000000"
  @createVerification "createBaseVerificationContract"
  @getVerification "getVerificationContract"
  @addr_prefix "0x"

  ##### Public #####

  @spec abi_file :: binary
  def abi_file, do: @abi_file

  @spec create_base_verification_contract(binary, binary, binary, binary, binary) :: {:ok, binary, binary} | {:error, binary, map}
  def create_base_verification_contract(contract_address, user_address, attestator_address, doc_type, session_tag) do
    params = {user_address, attestator_address, session_tag, doc_type}
    response = ContractServer.transaction(contract_address, VerificationContractFactory, @createVerification, params)

    case response do
      {:ok, tx_hash} -> {:ok, @createVerification, tx_hash}
      {:error, tx_receipt} -> {:error, @createVerification, tx_receipt}
    end
  end

  @spec get_verification_contract(binary, UUID) :: {:ok, binary} | {:error, :not_found}
  def get_verification_contract(contract_address, session_tag) do
    response = contract_address 
    |> ContractServer.call(VerificationContractFactory, @getVerification, {session_tag})

    case response do
      {:ok, @unverified} -> {:error, :not_found}
      {:ok, address} -> correct_address(address)
    end
  end

  ##### Private #####

  @spec correct_address(binary) :: {:ok, binary}
  defp correct_address(address) do
    address = address
    |> String.slice(-40..-1)
    |> add_prefix(@addr_prefix)

    {:ok, address}
  end

  @spec add_prefix(binary, binary) :: binary
  defp add_prefix(string, prefix), do: prefix <> string
end
