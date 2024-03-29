defmodule RpMobileWeb.DocumentController do
  @moduledoc false

  use RpMobileWeb, :controller

  ##### Public #####

  @spec index(Plug.Conn.t, map) :: Plug.Conn.t
  def index(conn, _) do
    {:ok, documents} = conn.assigns.account_address
    |> RpCore.documents_by_user_address
    
    render(conn, "v1.index.json", documents: documents)
  end
end
