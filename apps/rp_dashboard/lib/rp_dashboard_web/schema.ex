defmodule RpDashboardWeb.Schema do
  use Absinthe.Schema

  import_types RpDashboardWeb.Schema.ContentTypes

  alias RpDashboardWeb.Resolvers.{DocumentResolver, QrResolver, CompanyResolver}
  
  query do
    @desc "Get QR"
    field :qr, non_null(:qr) do
      resolve &QrResolver.qr/3
    end

    @desc "Get all documents"
    field :documents, non_null(list_of(non_null(:document))) do
      resolve &DocumentResolver.documents/3
    end

    @desc "Company details"
    field :company, non_null(:company) do
      resolve &CompanyResolver.company/3
    end
  end

  input_object :company_params do
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :website, :string
    field :phone, :string
    field :address, :string
    field :details, :string
  end

  mutation do
    field :company_update, type: :company do
      arg :id, non_null(:id)
      arg :company, non_null(:company_params)

      resolve &CompanyResolver.update/2
    end
  end
end