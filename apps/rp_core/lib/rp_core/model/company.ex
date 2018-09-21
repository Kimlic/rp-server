defmodule RpCore.Model.Company do
  @moduledoc false

  use RpCore.Model

  alias __MODULE__

  ##### Schema #####

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "company" do
    field :name, :string, null: false
    field :email, :string, null: false
    field :website, :string
    field :phone, :string
    field :address, :string
    field :details, :string

    timestamps()
  end

  @required_params ~w(name email)a
  @optional_params ~w(website phone address details)a

  ##### Public #####

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
  end

  def company do
    query = from c in Company,
      limit: 1

    case Repo.one(query) do
      nil -> {:error, :not_found}
      company -> {:ok, company}
    end
  end
end