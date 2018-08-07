defmodule RpFrontWeb.ErrorViewTest do
  use RpFrontWeb.ConnCase, async: true

  import Phoenix.View

  test "renders 404.json" do
    assert render(RpFrontWeb.ErrorView, "404.json", []) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500.json" do
    assert render(RpFrontWeb.ErrorView, "500.json", []) == %{errors: %{detail: "Internal Server Error"}}
  end
end
