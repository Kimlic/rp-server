defmodule RpQuorum do
  @moduledoc false
  
  use RpQuorum.Contract

  @unverified "0x0000000000000000000000000000000000000000000000000000000000000000"
  @verified "0x0000000000000000000000000000000000000000000000000000000000000001"

  ##### Public #####

  def create_account do
    {:ok, address} = "personal_newAccount"
    |> Ethereumex.HttpClient.request([""], [])

    Ethereumex.HttpClient.request("personal_unlockAccount", [address, ""], [])
    address
  end

  def unlock(account_address) do
    Ethereumex.HttpClient.request("personal_unlockAccount", [account_address, ""], [])
  end

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
    case res do
      {:ok, @verified} -> {:ok, :verified}
      {:ok, @unverified} -> {:ok, :unverified}
    end
  end

  def finalize_provisioning(contract_address) do
    {:ok, method, tx_hash} = contract_address
    |> ProvisioningContract.finalize_provisioning

    IO.inspect "finalize_provisioning: #{inspect method}   #{inspect tx_hash}"
    :ok
  end

  def get_verification_info(contract_address) do
    res = contract_address 
    |> ProvisioningContract.get_data
    
    IO.inspect "get_verification_info: #{inspect res}"
    res
  end

  def tokens_unlock_at(contract_address) do
    res = contract_address
    |> ProvisioningContract.tokens_unlock_at

    IO.puts "tokensUnlockAt address: #{inspect contract_address}   RES: #{inspect res}"
    res
  end

  def withdraw(contract_address) do
    res = contract_address
    |> ProvisioningContract.withdraw

    IO.puts "withdraw address: #{inspect contract_address}   RES: #{inspect res}"
    res
  end

  @spec get_verification_contract_factory(binary) :: binary
  def get_verification_contract_factory(contract_address) do
    res = contract_address
    |> KimlicContractsContext.get_verification_contract_factory

    IO.inspect "get_verification_contract_factory: #{inspect res}"
    res
  end

  def get_verification_contract(contract_address, session_tag) do
    res = contract_address
    |> VerificationContractFactory.get_verification_contract(session_tag)

    IO.inspect "get_verification_contract: #{inspect res}"
    res
  end

  def create_base_verification_contract(contract_address, user_address, attestator_address, doc_type, tag) do
    res = contract_address
    |> VerificationContractFactory.create_base_verification_contract(user_address, attestator_address, doc_type, tag)

    IO.inspect "create_base_verification_contract: #{inspect res}"
    res
  end
end
