defmodule RpDashboardWeb do

  def controller do
    quote do
      use Phoenix.Controller, namespace: RpDashboardWeb
      import Plug.Conn
      import RpDashboardWeb.Router.Helpers
      import RpDashboardWeb.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/rp_dashboard_web/templates", namespace: RpDashboardWeb

      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      import RpDashboardWeb.Router.Helpers
      import RpDashboardWeb.ErrorHelpers
      import RpDashboardWeb.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import RpDashboardWeb.Gettext
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
