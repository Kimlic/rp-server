defmodule RpUaf.Fido.Client do 
  @moduledoc false

  use HTTPoison.Base

  alias RpUaf.Fido.{ClientBehaviour, ResponseDecoder}

  @behaviour ClientBehaviour

  @filter_headers ["content-length", "Content-Length"]
  @request_headers [{"Content-Type", "application/json"}]

  @fido_facets "/uaf/facets"
  @fido_reg_request "/regRequest"
  @fido_reg_response "/regResponse"
  @fido_auth_request "/authRequest"
  @fido_auth_response "/uafAuthResponse"

  ##### Public #####

  def process_request_headers(headers) do
    headers
    |> Keyword.drop(@filter_headers)
    |> Kernel.++(@request_headers)
  end

  @spec facets :: {:ok, map} | {:error, tuple}
  def facets, do: get!(@fido_facets)

  @spec reg_request(binary) :: {:ok, map} | {:error, tuple}
  def reg_request(account_address) do
    @fido_reg_request <> "/" <> account_address
    |> get!
  end

  @spec reg_response(term) :: {:ok, map} | {:error, tuple}
  def reg_response(json) do
    json = json |> Jason.encode!

    @fido_reg_response
    |> post!(json)
  end

  @spec auth_request :: {:ok, map} | {:error, tuple}
  def auth_request, do: @fido_auth_request |> get!

  @spec auth_response(term) :: {:ok, map} | {:error, tuple}
  def auth_response(data) do
    @fido_auth_response
    |> post!(Jason.encode!(data))
  end

  @spec request!(binary, binary, binary, list, list) :: {:ok, map} | {:error, tuple}
  def request!(method, url, body \\ "", headers \\ [], options \\ []) do 
    super(method, fido_url() <> url, body, headers, options)
    |> ResponseDecoder.check_response()
  end

  ##### Private #####

  defp fido_url, do: Application.get_env(:rp_uaf, __MODULE__)[:url]
end
