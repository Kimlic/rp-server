defmodule RpDashboardWeb.Schema do
  use Absinthe.Schema

  import_types RpDashboardWeb.Schema.ContentTypes

  alias RpDashboardWeb.Resolvers.{DocumentResolver, QrResolver}
  
  query do
    @desc "Get QR"
    field :qr, non_null(:qr) do
      resolve &QrResolver.qr/3
    end

    @desc "Get all documents"
    field :documents, non_null(list_of(non_null(:document))) do
      resolve &DocumentResolver.documents/3
    end
  end
end