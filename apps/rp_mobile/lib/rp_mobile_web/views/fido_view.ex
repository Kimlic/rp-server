defmodule RpMobileWeb.FidoView do
  use RpMobileWeb, :view

  def render("v1.facets.json", %{fido: facets}) do
    %{data: render_one(facets, RpMobileWeb.FidoView, "facets.json")}
  end

  def render("v1.reg_request.json", %{fido: request}) do
    %{data: render_one(request, RpMobileWeb.FidoView, "request.json")}
  end

  def render("v1.reg_response.json", %{fido: response}) do
    %{data: render_one(response, RpMobileWeb.FidoView, "response.json")}
  end

  def render("v1.auth_request.json", %{fido: request}) do
    %{data: render_one(request, RpMobileWeb.FidoView, "request.json")}
  end

  def render("v1.auth_response.json", %{fido: response}) do
    %{data: render_one(response, RpMobileWeb.FidoView, "response.json")}
  end

  def render("facets.json", %{fido: facets}), do: %{facets: facets}

  def render("request.json", %{fido: request}), do: %{request: request}

  def render("response.json", %{fido: response}), do: %{response: response}
end