defmodule RpQuorum.ContractServer do

  alias RpQuorum.ContractLoader

  @transaction_delay Application.get_env(:rp_quorum, :transaction_delay)

  ##### Public #####

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
            :timer.sleep(@transaction_delay)
            call(contract_address, module, method, params, attempt + 1)
        end
    end
  end 

  def transaction(contract_address, module, method, params \\ {}, attempt \\ 1) do
      data = ContractLoader.hash_data(module, method, [params])
      eth_params = %{
        from: account_address(), 
        to: contract_address, 
        data: data,
        gasPrice: "0x0", 
        gas: "0x4612388"
      }

      case Ethereumex.HttpClient.eth_send_transaction(eth_params, []) do
        {:ok, transaction_hash} -> receipt(transaction_hash)
        
        {:error, %{"code" => -32000, "message" => "authentication needed: password or unlock"}} ->
          {__MODULE__, :transaction, [contract_address, module, method, params, attempt]}
          |> unlock_account(account_address(), "")

        {:error, %{"code" => -32000, "message" => "could not decrypt key with given passphrase"}} -> 
          {__MODULE__, :transaction, [contract_address, module, method, params, attempt]}
          |> unlock_account(account_address())
          
        {:error, err} ->
          case attempt do
            3 -> {:error, err}
            _ ->
              :timer.sleep(@transaction_delay)
              transaction(contract_address, module, method, params, attempt + 1)
          end
      end
  end

  ##### Private #####

  defp receipt(tx_hash, attempt \\ 1) do
    :timer.sleep(@transaction_delay)

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

  defp unlock_account({m, f, a}, account_address, password \\ "") do
    with {:ok, true} <- Ethereumex.HttpClient.request("personal_unlockAccount", [account_address, password], []) do
      apply(m, f, a)
    end
  end

  defp env(param), do: Application.get_env(:rp_quorum, param)
end