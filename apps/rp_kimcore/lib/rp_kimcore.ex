defmodule RpKimcore do
  @moduledoc false

  alias RpKimcore.Schemes.Config

  ##### Public #####

  @spec config() :: {:ok, map} | {:error, binary}
  def config, do: kim_config() |> request

  ##### Private #####

  defp request(endpoint) do
    req_url = kim_endpoint() <> endpoint
    req_options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]
    req_headers = %{"account-address" => account_address()}
    
    case HTTPoison.get(req_url, req_headers, req_options) do
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
      {:ok, %HTTPoison.Response{body: body}} -> 
        changeset = body
        |> Jason.decode!()
        |> Map.fetch!("data")
        |> Config.changeset()
        
        case changeset.valid? do
          true -> {:ok, Ecto.Changeset.apply_changes(changeset)}
          false -> {:error, changeset.errors}
        end
    end
  end

  defp account_address, do: :account_address |> env

  defp kim_endpoint, do: :kim_endpoint |> env

  defp kim_config, do: :kim_config |> env

  defp env(param), do: Application.get_env(:rp_kimcore, param)
end
