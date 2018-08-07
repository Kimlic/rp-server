defmodule RpMobileWeb.ConnCase do

  use ExUnit.CaseTemplate

  using do
    quote do
      use Phoenix.ConnTest
      import RpMobileWeb.Router.Helpers

      @endpoint RpMobileWeb.Endpoint
    end
  end


  setup _tags do
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
