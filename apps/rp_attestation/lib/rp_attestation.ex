defmodule RpAttestation do
  @moduledoc false

  ##### Public #####

  @spec vendors() :: {:ok, map} | {:error, binary}
  def vendors, do: ap_vendors() |> request

  ##### Private #####

  defp request(endpoint) do
    req_url = ap_endpoint() <> endpoint
    req_options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 500]
    req_headers = %{"account-address" => account_address()}
    
    case HTTPoison.get(req_url, req_headers, req_options) do
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
      {:ok, %HTTPoison.Response{body: body}} -> 
        json = Jason.decode!(body)
        {:ok, json}
    end
  end

  defp account_address, do: :account_address |> env

  defp ap_endpoint, do: :ap_endpoint |> env

  defp ap_vendors, do: :ap_vendors |> env

  defp env(param), do: Application.get_env(:rp_attestation, param)
end
