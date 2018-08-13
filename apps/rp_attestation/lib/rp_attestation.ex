defmodule RpAttestation do
  @moduledoc false

  ##### Public #####

  @spec vendors() :: {:ok, map} | {:error, binary}
  def vendors, do: ap_vendors() |> get

  def session_create(first_name, last_name, document_type, contract_address, device_os, device_token) do
    params = %{
      first_name: first_name, 
      last_name: last_name, 
      lang: "en",
      document_type: document_type, 
      contract_address: contract_address, 
      timestamp: "#{:os.system_time(:seconds)}",
      device_os: device_os, 
      device_token: device_token
    }
    ap_session_create() |> post(params)
  end

  ##### Private #####

  defp get(endpoint) do
    req_url = ap_endpoint() <> endpoint
    req_options = [ssl: [{:versions, [:'tlsv1.2']}], timeout: 30_000, recv_timeout: 30_000]
    req_headers = %{"account-address" => account_address()}
    
    case HTTPoison.get(req_url, req_headers, req_options) do
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
      {:ok, %HTTPoison.Response{body: body}} -> 
        json = Jason.decode!(body)
        {:ok, json}
    end
  end

  defp post(endpoint, params) do
    req_url = ap_endpoint() <> endpoint
    req_options = [ssl: [{:versions, [:'tlsv1.2']}], timeout: 30_000, recv_timeout: 30_000]
    req_headers = %{
      "account-address" => account_address(),
      "Content-Type" => "application/json"
    }
    req_body = Jason.encode!(params)
    IO.inspect "PARAMS: #{inspect req_body}"
    case HTTPoison.post(req_url, req_body, req_headers, req_options) do
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
      {:ok, %HTTPoison.Response{body: body}} -> 
        json = Jason.decode!(body)
        {:ok, json}
    end
  end

  defp account_address, do: :account_address |> env

  defp ap_endpoint, do: :ap_endpoint |> env

  defp ap_vendors, do: :ap_vendors |> env

  defp ap_session_create, do: :ap_session_create |> env

  defp env(param), do: Application.get_env(:rp_attestation, param)
end
