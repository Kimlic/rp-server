defmodule RpQuorum.ContractServer do

  alias RpQuorum.ContractLoader
  alias Ethereumex.HttpClient

  @gas_price "0x0"
  @gas_limit "0x4612388"
  @tx_failed "0x0"
  @tx_success "0x1"

  ##### Public #####

  def call(contract_address, module, method, params \\ {}, attempt \\ 1) do
    data = ContractLoader.hash_data(module, method, [params])
    eth_params = %{
      from: account_address(), 
      to: contract_address, 
      data: data,
      gasPrice: @gas_price, 
      gas: @gas_limit
    }

    case HttpClient.eth_call(eth_params, "latest", []) do
      {:ok, response} -> {:ok, response}
      {:error, err} ->
        case attempt do
          3 -> {:error, err}
          _ ->
            sleep()
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
        gasPrice: @gas_price, 
        gas: @gas_limit
      }

      case HttpClient.eth_send_transaction(eth_params, []) do
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
              sleep()
              transaction(contract_address, module, method, params, attempt + 1)
          end
      end
  end

  ##### Private #####

  defp receipt(tx_hash, attempt \\ 1) do
    sleep()

    case HttpClient.eth_get_transaction_receipt(tx_hash, []) do
      {:ok, %{"status" => @tx_success}} -> {:ok, tx_hash}
      {:ok, %{"status" => @tx_failed} = receipt} -> {:error, receipt}
      {:ok, nil} -> 
        case attempt do
          3 -> {:error, "No receipt for #{tx_hash}"}
          _ -> receipt(tx_hash, attempt + 1)
        end
    end
  end

  defp unlock_account({m, f, a}, account_address, password \\ "") do
    params = [account_address, password]

    "personal_unlockAccount"
    |> HttpClient.request(params, [])
    |> case do
      {:ok, true} -> apply(m, f, a)
    end
  end

  @spec sleep :: :ok
  defp sleep, do: transaction_delay() |> :timer.sleep

  @spec transaction_delay :: number
  defp transaction_delay, do: env(:transaction_delay)

  @spec account_address :: binary
  defp account_address, do: env(:account_address)

  @spec env(atom) :: binary
  defp env(param), do: Application.get_env(:rp_quorum, param)
end