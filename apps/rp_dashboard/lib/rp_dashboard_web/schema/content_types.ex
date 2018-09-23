defmodule RpDashboardWeb.Schema.ContentTypes do
  @moduledoc false

  use Absinthe.Schema.Notation

  object :qr do
    field :code, non_null(:string)
  end

  object :document do
    field :id, non_null(:id)
    field :user_address, non_null(:string)
    field :type, non_null(:string)
    field :first_name, non_null(:string)
    field :last_name, non_null(:string)
    field :country, non_null(:string)
  end

  object :logo do
    field :id, non_null(:id)
    field :file, non_null(:string)
    field :company_id, non_null(:string)
    field :url, non_null(:string)
  end

  object :company do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :email, non_null(:string)
    field :website, :string
    field :phone, :string
    field :address, :string
    field :details, :string
  end
end