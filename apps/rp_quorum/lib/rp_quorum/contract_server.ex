defmodule RpQuorum.ContractServer do

  alias RpQuorum.ContractLoader

  ##### Public #####

  # def create_unlocked_account(password) do
  #   "personal_newAccount"
  #   |> Ethereumex.HttpClient.request([password], [])
  #   |> unlock_account(password)
  # end

  def account_address, do: :account_address |> env

  def call(contract_address, module, method, params \\ {}, attempt \\ 1) do
    data = ContractLoader.hash_data(module, method, [params])
    eth_params = %{
      from: account_address(), 
      to: contract_address, 
      data: data,
      gasPrice: "0x0", 
      gas: "0x4612388"
    }

    case Ethereumex.HttpClient.eth_call(eth_params, "latest", []) do
      {:ok, response} -> {:ok, response}
      {:error, err} ->
        case attempt do
          3 -> {:error, err}
          _ ->
            :timer.sleep(50)
            call(contract_address, method, attempt + 1)
        end
    end
  end 

  def transaction(contract_address, module, method, params \\ {}, attempt \\ 1) do
    with {:ok, _address} <- unlock_account(account_address(), "password") do
      data = ContractLoader.hash_data(module, method, [params])
      eth_params = %{
        from: account_address(), 
        to: contract_address, 
        data: data,
        gasPrice: "0x0", 
        gas: "0x4612388"
      }

      IO.inspect "TX PARAMS: #{inspect eth_params}"

      case Ethereumex.HttpClient.eth_send_transaction(eth_params, []) do
        {:ok, transaction_hash} -> receipt(transaction_hash)
        {:error, err} ->
          case attempt do
            3 -> {:error, err}
            _ ->
              :timer.sleep(100)
              transaction(contract_address, module, method, params, attempt + 1)
          end
      end
    end
  end

  ##### Private #####

  defp receipt(tx_hash, attempt \\ 1) do
    :timer.sleep(100)

    case Ethereumex.HttpClient.eth_get_transaction_receipt(tx_hash, []) do
      {:ok, %{"status" => "0x1"}} -> {:ok, tx_hash}
      {:ok, %{"status" => "0x0"} = receipt} -> {:error, receipt}
      {:ok, nil} -> 
        case attempt do
          3 -> {:error, "No receipt for #{tx_hash}"}
          _ -> receipt(tx_hash, attempt + 1)
        end
    end
  end

  defp unlock_account(account_address, password) do
    with {:ok, true} <- Ethereumex.HttpClient.request("personal_unlockAccount", [account_address, password], []) do
      {:ok, account_address}
    end
  end

  defp env(param), do: Application.get_env(:rp_quorum, param)
end