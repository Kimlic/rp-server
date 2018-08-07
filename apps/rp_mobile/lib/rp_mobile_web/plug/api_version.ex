defmodule RpMobileWeb.Plug.ApiVersion do
  @moduledoc false

  import Plug.Conn

  @versions Application.get_env(:mime, :types)

  ##### Public #####

  def init(opts), do: opts

  def call(conn, _opts) do
    [accept] = get_req_header(conn, "accept")
    version = Map.fetch(@versions, accept)

    _call(conn, version)
  end

  ##### Private #####

  defp _call(conn, {:ok, [version]}), do: assign(conn, :version, version)
  defp _call(conn, _) do
    send_resp(conn, :not_found, "")
    |> halt()
  end
end