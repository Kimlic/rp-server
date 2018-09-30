defmodule RpMobileWeb.DocumentView do
  use RpMobileWeb, :view

  def render("v1.index.json", %{documents: documents}) do
    %{data: render_many(documents, RpMobileWeb.DocumentView, "document.json")}
  end

  def render("document.json", %{document: document}), do: %{document: document}
end