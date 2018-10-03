defmodule RpHttp do
  @moduledoc false

  @content_type "application/json"
  @accept "application/json; charset=utf-8"
  @recv_timeout 30_000
  
  ##### Public #####

  def get(req_url) do
    req_url
    |> HTTPoison.get(req_headers(), req_options())
    |> response
  end

  def post(req_url, params) do
    req_body = Jason.encode!(params)
    
    req_url
    |> HTTPoison.post(req_body, req_headers(), req_options())
    |> response
  end

  ##### Private #####

  defp req_headers do
    %{
      "account-address" => account_address(),
      "Content-Type" => @content_type,
      "Accept" => @accept
    }
  end

  defp req_options do
    [
      hackney: [
        follow_redirect: true,
        pool: :ap_server
      ], 
      ssl: [versions: [:'tlsv1.2']], 
      recv_timeout: @recv_timeout
    ]
  end

  defp response({:error, %HTTPoison.Error{reason: reason}}), do: {:error, reason}
  defp response({:ok, %HTTPoison.Response{body: body}}) do
    json = Jason.decode!(body)
    {:ok, json}
  end

  defp account_address, do: Application.get_env(:rp_http, :account_address)
end
