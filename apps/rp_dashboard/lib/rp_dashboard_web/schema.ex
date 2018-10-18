defmodule RpDashboardWeb.Schema do
  use Absinthe.Schema

  import_types RpDashboardWeb.Schema.ContentTypes
  import_types Absinthe.Plug.Types

  alias RpDashboardWeb.Resolvers.{
    DocumentResolver, 
    QrResolver, 
    CompanyResolver, 
    AttestatorResolver,
    FinanceResolver
  }
  
  query do
    @desc "Get QR"
    field :qr, non_null(:qr) do
      resolve &QrResolver.qr/3
    end

    @desc "Get all documents"
    field :documents, non_null(list_of(non_null(:document))) do
      resolve &DocumentResolver.documents/3
    end

    field :document, :document do
      arg :id, non_null(:id)
      resolve &DocumentResolver.document/3
    end

    field :count_documents, list_of(:documents_counter) do
      resolve &DocumentResolver.count_documents/3
    end

    @desc "Company details"
    field :company, non_null(:company) do
      resolve &CompanyResolver.company/3
    end

    @desc "Get logo"
    field :logo, non_null(:logo) do
      resolve &CompanyResolver.logo/3
    end

    @desc "Get attestators"
    field :attestators, list_of(:attestator) do
      resolve &AttestatorResolver.attestators/3
    end

    field :balance, :balance do
      resolve &FinanceResolver.balance/3
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

    field :logo_update, type: :logo do
      arg :file, non_null(:upload)
      arg :company_id, non_null(:string)

      resolve &CompanyResolver.logo_update/2
    end
  end
end