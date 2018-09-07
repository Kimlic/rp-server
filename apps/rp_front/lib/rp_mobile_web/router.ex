defmodule RpFrontWeb.Router do
  use RpFrontWeb, :router
  use Plug.ErrorHandler

  alias Plug.LoggerJSON

  require Logger

  pipeline :api do
    plug :accepts, ["json-api"]
  end

  scope "/api", RpFrontWeb do
    pipe_through :api

    get "/ping", PingController, :index
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
