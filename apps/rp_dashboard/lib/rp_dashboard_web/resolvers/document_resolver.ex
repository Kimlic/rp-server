defmodule RpDashboardWeb.Resolvers.DocumentResolver do

  def documents(_parent, _args, _resolution), do: {:ok, RpCore.documents()}

  def document(_, %{id: id}, _), do: {:ok, RpCore.documentById(id)}

  def count_documents(_, _, _), do: {:ok, RpCore.count_documents()}
end