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