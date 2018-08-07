defmodule RpMobileWeb.MediaView do
  use RpMobileWeb, :view

  def render("v1.create.json", %{media: media}) do
    %{data: render_one(media, RpMobileWeb.MediaView, "media.json")}
  end

  def render("media.json", %{media: media}), do: %{media: media}
end