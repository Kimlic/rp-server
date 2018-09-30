defmodule RpMobileWeb.DocumentController do
  @moduledoc false

  use RpMobileWeb, :controller

  ##### Public #####

  @spec index(Conn.t(), map) :: Conn.t()
  def index(conn, %{"type" => "verified"}) do
    user_address = conn.assigns.account_address
    
    case RpCore.documents_verified(user_address) do
      {:error, :not_found} -> send_resp(conn, :not_found, "")
      {:ok, documents} -> render(conn, "v1.index.json", documents: documents)
    end
  end
end
