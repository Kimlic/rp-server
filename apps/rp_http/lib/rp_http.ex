defmodule RpHttp do
  @moduledoc false

  @content_type "application/json"
  @accept "application/json; charset=utf-8"
  @recv_timeout 30_000
  @pools [:kim_pool, :ap_pool]

  ##### Public #####
  
  @spec get(binary, atom) :: {:ok, map} | {:error, binary} | {:error, atom}
  def get(req_url, pool) when pool in @pools do
    req_url
    |> HTTPoison.get(req_headers(), req_options(pool))
    |> response
  end

  @spec post(binary, map, atom) :: {:ok, map} | {:error, binary} | {:error, atom}
  def post(req_url, params, pool) when pool in @pools do
    req_body = Jason.encode!(params)
    
    req_url
    |> HTTPoison.post(req_body, req_headers(), req_options(pool))
    |> response
  end

  ##### Private #####

  @spec req_headers() :: map
  defp req_headers do
    %{
      "account-address" => account_address(),
      "Content-Type" => @content_type,
      "Accept" => @accept
    }
  end

  @spec req_options(atom) :: list
  defp req_options(pool) do
    [
      hackney: [
        follow_redirect: true,
        pool: pool
      ], 
      ssl: [versions: [:'tlsv1.2']], 
      recv_timeout: @recv_timeout
    ]
  end

  @spec response({atom, HTTPoison.Error.t()}) :: {:error, binary}
  defp response({:error, %HTTPoison.Error{reason: reason}}), do: {:error, reason}

  @spec response({atom, HTTPoison.Response.t()}) :: {:ok, map}
  defp response({:ok, %HTTPoison.Response{body: body}}) do
    json = Jason.decode!(body)
    {:ok, json}
  end

  @spec account_address() :: binary
  defp account_address, do: Application.get_env(:rp_http, :account_address)
end
