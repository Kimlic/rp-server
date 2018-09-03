defmodule RpQuorum.Contract.VerificationContractFactory do
  @moduledoc false

  use RpQuorum.Contract

  ##### Public #####

  @spec abi_file() :: binary
  def abi_file, do: "verification_contract_factory.json"

  @spec create_base_verification_contract(binary, binary, binary, binary, binary) :: {:ok, binary, binary} | {:error, binary, map}
  def create_base_verification_contract(contract_address, user_address, attestator_address, doc_type, session_tag) do
    params = {user_address, attestator_address, session_tag, doc_type}
    IO.puts "createBaseVerificationContract address: #{contract_address}   params: #{inspect params}"
    response = ContractServer.transaction(contract_address, VerificationContractFactory, "createBaseVerificationContract", params)

    case response do
      {:ok, tx_hash} -> {:ok, "createBaseVerificationContract", tx_hash}
      {:error, tx_receipt} -> {:error, "createBaseVerificationContract", tx_receipt}
    end
  end

  def get_verification_contract(contract_address, session_tag) do
    response = contract_address 
    |> ContractServer.call(VerificationContractFactory, "getVerificationContract", {session_tag})

    case response do
      {:ok, "0x0000000000000000000000000000000000000000000000000000000000000000"} -> {:error, :not_found}
      {:ok, address} ->
        address = address
        |> String.slice(-40..-1)
        |> add_prefix("0x")

        {:ok, address}
    end
  end

  ##### Private #####

  @spec add_prefix(binary, binary) :: binary
  defp add_prefix(string, prefix), do: prefix <> string
end
