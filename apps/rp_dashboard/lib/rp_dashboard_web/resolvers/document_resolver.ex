defmodule RpDashboardWeb.Resolvers.DocumentResolver do

  def documents(_parent, _args, _resolution), do: RpCore.documents()

  def document(_, %{id: id}, _), do: RpCore.document_by_id(id)

  def count_documents(_, _, _), do: RpCore.count_documents()
end