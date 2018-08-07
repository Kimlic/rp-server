defmodule RpMobileWeb.PingController do
    @moduledoc false

    use RpMobileWeb, :controller
  
    def ping(conn, _), do: send_resp(conn, :ok, "Pong")

    def rabbit_job(conn, _) do
        RpEventbus.rabbit_job
        
        send_resp(conn, :ok, "Rabbit Pong")
    end
end
  