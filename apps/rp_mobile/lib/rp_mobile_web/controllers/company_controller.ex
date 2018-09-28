defmodule RpMobileWeb.CompanyController do
  @moduledoc false

  use RpMobileWeb, :controller

  ##### Public #####

  @spec show(Conn.t(), map) :: Conn.t()
  def show(%{assigns: %{version: :v1}} = conn, _params) do
    {:ok, company} = RpCore.company_details()
    render(conn, "v1.show.json", company: company)
  end
end