defmodule RpMobileWeb.Router do
  use RpMobileWeb, :router

  if Mix.env == :dev, do: use Plug.Debugger
  use Plug.ErrorHandler

  alias RpMobileWeb.Plug.AccountAddress
  alias RpMobileWeb.Plug.ApiVersion

  require Logger

  ##### Router #####

  pipeline :browser do
  end

  pipeline :api do
    plug :accepts, [:v1]
    plug ApiVersion
    plug AccountAddress
    plug :put_resp_content_type, MIME.type("json")
  end

  scope "/api", RpMobileWeb do
    pipe_through :api

    ##### API v1 #####

    get "/vendors", ApController, :index
    post "/medias", MediaController, :create
    get "/company", CompanyController, :show
    get "/documents", DocumentController, :index

    ##### UAF #####

    # get("/uaf/facets", FidoController, :facets)
    # get("/uaf/reg_request", FidoController, :reg_request)
    # post("/uaf/reg_response", FidoController, :reg_response)
    # get("/uaf/auth_request", FidoController, :auth_request)
    # post("/uaf/auth_response", FidoController, :auth_response)
    # get("/uaf/is_registered", FidoController, :is_registered)
    # head("/uaf/is_registered", FidoController, :is_registered)

    get("/qr_callback", QrController, :callback)
  end

  scope "/", RpMobileWeb do
    pipe_through :browser

    get("/qr", QrController, :show)
  end

  ##### Plug.ErrorHandler #####

  defp handle_errors(%Plug.Conn{status: 500} = conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    Logger.log(:info, fn ->
      Jason.encode!(%{
        "log_type" => "error",
        "request_params" => conn.params,
        "request_id" => Logger.metadata()[:request_id]
      })
    end)

    send_resp(conn, 500, "")
  end

  defp handle_errors(%Plug.Conn{status: 406} = conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    Logger.log(:info, fn ->
      Jason.encode!(%{
        "log_type" => "error",
        "request_params" => conn.params,
        "request_id" => Logger.metadata()[:request_id]
      })
    end)

    send_resp(conn, 406, "")
  end

  defp handle_errors(conn, _), do: conn
end
