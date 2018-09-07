defmodule RpFrontWeb.ConnCase do

  use ExUnit.CaseTemplate

  using do
    quote do
      use Phoenix.ConnTest
      import RpFrontWeb.Router.Helpers

      @endpoint RpFrontWeb.Endpoint
    end
  end


  setup _tags do
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
