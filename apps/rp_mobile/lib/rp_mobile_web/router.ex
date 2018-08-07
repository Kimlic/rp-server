defmodule RpMobileWeb.Router do
  use RpMobileWeb, :router
  use Plug.ErrorHandler

  alias RpMobileWeb.Plug.AccountAddress
  alias RpMobileWeb.Plug.ApiVersion
  alias Plug.LoggerJSON

  require Logger

  pipeline :api do
    plug :accepts, [:v1]
    plug ApiVersion
    plug AccountAddress
  end

  scope "/api", RpMobileWeb do
    pipe_through :api

    ##### demo #####

    post "/rabbit_job", PingController, :rabbit_job

    ##### API v1 #####

    get "/vendors", ApController, :index
    post "/medias", MediaController, :create

    ##### UAF #####

    # get("/uaf/facets", FidoController, :facets)
    # get("/uaf/reg_request", FidoController, :reg_request)
    post("/uaf/reg_response", FidoController, :reg_response)
    # get("/uaf/auth_request", FidoController, :auth_request)
    post("/uaf/auth_response", FidoController, :auth_response)
    get("/uaf/is_registered", FidoController, :is_registered)
    head("/uaf/is_registered", FidoController, :is_registered)

    post("/qr", QrController, :create)
    get("/qr_callback", QrController, :callback)
  end

  defp handle_errors(%Plug.Conn{status: 500} = conn, %{kind: kind, reason: reason, stack: stacktrace}) do
    LoggerJSON.log_error(kind, reason, stacktrace)

    Logger.log(:info, fn ->
      Jason.encode!(%{
        "log_type" => "error",
        "request_params" => conn.params,
        "request_id" => Logger.metadata()[:request_id]
      })
    end)

    send_resp(conn, 500, Jason.encode!(%{errors: %{detail: "Internal server error"}}))
  end
  defp handle_errors(_, _), do: nil
end
