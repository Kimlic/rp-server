defmodule RpMobileWeb.QrController do
  @moduledoc false

  use RpMobileWeb, :controller

  alias RpUaf.Fido.Qr

  ##### Public #####
  
  @spec show(Plug.Conn.t, map) :: Plug.Conn.t | no_return
  def show(conn, _) do
    url = Application.get_env(:rp_mobile, :endpoint)

    {:ok, scope_request} = RpUaf.create_scope_request()
    qr = Qr.generate_qr_code(scope_request)
    render(conn, "show.html", %{qr: qr, url: url})

    # conn
    # |> put_resp_content_type("image/png")
    # |> send_resp(:created, response)
  end

  # @spec callback(Conn.t(), map) :: conn | no_return
  # def callback(conn, %{"scope_request" => id}) do
  #   with account_address <- conn.assigns.account_address,
  #   {:ok, %{scope_request: _, fido: _} = resp} <- RpUaf.process_scope_request(id, account_address) do
  #     json(conn, resp)
  #   else
  #     {:error, :scope_request_already_processed} -> json(conn, %{error: "Scope request already processed"})
  #     {:error, :scope_request_expired} -> json(conn, %{error: "Scope request expired"})
  #     _ -> send_resp(conn, :unprocessable_entity, %{error: "Request error"})
  #   end
  # end
end