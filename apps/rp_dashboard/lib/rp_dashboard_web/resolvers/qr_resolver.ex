defmodule RpDashboardWeb.Resolvers.QrResolver do

  alias RpUaf.Fido.Qr

  def qr(_parent, _args, _resolution) do
    code = RpUaf.create_scope_request
    |> Kernel.elem(1)
    |> Qr.generate_qr_code
    |> Base.encode64

    {:ok, %{code: code}}
  end
end