defmodule RpMobileWeb.QrView do
  use RpMobileWeb, :view

  def render("show.html", %{qr: qr, url: _url}) do
    pic = Base.encode64(qr)
    Phoenix.HTML.raw("<img class=\"my-5\" src=\"data:image/png;base64," <> pic <> "\" height=300 width=300>")
  end
end