defmodule RpMobileWeb.ApController do
  @moduledoc false

  use RpMobileWeb, :controller

  ##### Public #####

  @spec index(Plug.Conn.t, map) :: Plug.Conn.t
  def index(conn, _) do
    with {:ok, vendors} <- RpAttestation.vendors do
      json(conn, vendors)
    else
      {:error, reason} -> send_resp(conn, :failed_dependency, reason)
    end
  end
end
