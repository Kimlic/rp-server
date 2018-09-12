defmodule RpDashboardWeb.Router do
  use RpDashboardWeb, :router

  scope "/" do
    forward "/graphiql",
      Absinthe.Plug.GraphiQL,
      schema: RpDashboardWeb.Schema,
      interface: :advanced

    forward "/api", Absinthe.Plug, schema: RpDashboardWeb.Schema
  end
end
