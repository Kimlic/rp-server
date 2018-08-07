defmodule RpMobileWeb.FidoController do
  @moduledoc false

  use RpMobileWeb, :controller

  alias RpMobileWeb.FallbackController

  action_fallback FallbackController

  def facets(conn, _) do
    with {:ok, resp} <- RpUaf.facets do
      render(conn, "v1.facets.json", fido: resp)
    end
  end

  def reg_request(conn, _) do
    with account_address <- conn.assigns.account_address,
    {:ok, resp} <- RpUaf.reg_request(account_address) do
      render(conn, "v1.reg_request.json", fido: resp)
    end
  end

  def reg_response(conn, %{"_json" => json}), do: reg_response(conn, json)
  def reg_response(conn, json) do
    with {:ok, resp} <- RpUaf.reg_response(json) do
      render(conn, "v1.reg_response.json", fido: resp)
    end
  end

  def auth_request(conn, _) do
    with {:ok, resp} <- RpUaf.auth_request do
      render(conn, "v1.auth_request.json", fido: resp)
    end
  end

  def auth_response(conn, %{"_json" => json}), do: auth_response(conn, json)
  def auth_response(conn, json) do
    with {:ok, resp} <- RpUaf.auth_response(json) do
      render(conn, "v1.auth_response.json", fido: resp)
    end
  end

  def is_registered(conn, _) do
    with account_address <- conn.assigns.account_address do
      case RpUaf.account_registered?(account_address) do
        true -> send_resp(conn, :no_content, "")
        _ -> send_resp(conn, :not_found, "")
      end
    end
  end
end