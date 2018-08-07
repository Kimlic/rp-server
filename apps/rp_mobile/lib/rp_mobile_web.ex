defmodule RpMobileWeb do

  def controller do
    quote do
      use Phoenix.Controller, namespace: RpMobileWeb

      import Plug.Conn
      import RpMobileWeb.Router.Helpers
      import RpMobileWeb.Gettext

      alias RpMobileWeb.FallbackController
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/rp_mobile_web/templates", namespace: RpMobileWeb

      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      import RpMobileWeb.Router.Helpers
      import RpMobileWeb.ErrorHelpers
      import RpMobileWeb.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
