defmodule RpDashboardWeb.Resolvers.DocumentResolver do

  def documents(_parent, _args, _resolution) do
    {:ok, RpCore.documents()}
  end
end