defmodule RpDashboardWeb.ConnCase do

  use ExUnit.CaseTemplate

  using do
    quote do
      use Phoenix.ConnTest
      import RpDashboardWeb.Router.Helpers

      @endpoint RpDashboardWeb.Endpoint
    end
  end


  setup _tags do
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
