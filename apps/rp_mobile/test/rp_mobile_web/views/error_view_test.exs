defmodule RpMobileWeb.ErrorViewTest do
  use RpMobileWeb.ConnCase, async: true

  import Phoenix.View

  test "renders 404.json" do
    assert render(RpMobileWeb.ErrorView, "404.json", []) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500.json" do
    assert render(RpMobileWeb.ErrorView, "500.json", []) == %{errors: %{detail: "Internal Server Error"}}
  end
end
