defmodule RpDashboardWeb.Router do
  use RpDashboardWeb, :router

  post("/", Absinthe.Plug.GraphiQL, schema: MyApp.Graphql.Schema, json_codec: Jason)

  scope "/" do
    forward "/graphiql",
      Absinthe.Plug.GraphiQL,
      schema: RpDashboardWeb.Schema,
      json_codec: Jason,
      interface: :advanced

    forward "/dashboard", 
      Absinthe.Plug, 
      schema: RpDashboardWeb.Schema,
      json_codec: Jason
  end
end
