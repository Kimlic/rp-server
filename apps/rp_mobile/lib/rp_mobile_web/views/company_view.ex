defmodule RpMobileWeb.CompanyView do
  use RpMobileWeb, :view

  def render("v1.show.json", %{company: company}) do
    %{data: render_one(company, RpMobileWeb.CompanyView, "company.json")}
  end

  def render("company.json", %{company: company}), do: %{company: company}
end