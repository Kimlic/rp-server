defmodule RpDashboardWeb.Resolvers.DocumentResolver do

  def documents(_parent, _args, _resolution), do: {:ok, RpCore.documents()}

  def count_documents(_, _, _), do: {:ok, RpCore.count_documents()}
end