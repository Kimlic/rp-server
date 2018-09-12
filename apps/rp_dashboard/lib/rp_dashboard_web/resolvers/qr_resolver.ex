defmodule RpDashboardWeb.Resolvers.QrResolver do

  alias RpUaf.Fido.Qr

  def qr(_parent, _args, _resolution) do
    {:ok, scope_request} = RpUaf.create_scope_request()
    qr = Qr.generate_qr_code(scope_request)
    code = Base.encode64(qr)
    {:ok, %{code: code}}
  end
end