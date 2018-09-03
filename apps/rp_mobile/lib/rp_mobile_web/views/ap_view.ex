defmodule RpMobileWeb.ApView do
  use RpMobileWeb, :view

  def render("v1.vendors.json", %{ap: vendors}), do: vendors
end