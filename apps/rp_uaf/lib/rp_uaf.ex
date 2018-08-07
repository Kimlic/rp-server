defmodule RpUaf do
  @moduledoc false
  
  alias RpUaf.Model.ScopeRequest
  alias RpUaf.Fido.{Client, Qr, Request}

  ##### Public ######

  def facets, do: Client.facets

  def reg_request(account_address), do: account_address |> Client.reg_request

  def reg_response(json), do: Client.reg_response(json)

  def auth_request, do: Client.auth_request

  def auth_response(params), do: Client.auth_response(params)

  def account_registered?(account_address), do: Request.account_registered?(account_address)

  def create_scope_request, do: Qr.create_scope_request()

  @spec generate_qr_code(%ScopeRequest{}) :: binary
  def generate_qr_code(request), do: request |> Qr.generate_qr_code

  @spec process_scope_request(binary, binary) :: Qr.process_scope_request_response
  def process_scope_request(id, account_address), do: Qr.process_scope_request(id, account_address)
end 