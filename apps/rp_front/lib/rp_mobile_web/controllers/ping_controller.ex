defmodule RpFrontWeb.PingController do
    use RpFrontWeb, :controller
  
    def index(conn, _), do: send_resp(conn, :ok, "Pong")
end
  