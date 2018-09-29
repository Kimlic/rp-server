defmodule RpCore.Model.Company do
  @moduledoc false

  use RpCore.Model

  alias __MODULE__

  ##### Schema #####

  @derive {Jason.Encoder, except: [:__meta__, :inserted_at, :updated_at]}
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "companys" do
    field :name, :string, null: false
    field :email, :string, null: false
    field :website, :string
    field :phone, :string
    field :address, :string
    field :details, :string

    has_one :logo, Logo, foreign_key: :company_id, on_delete: :delete_all

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

  def company_details do
    query = from c in Company,
      left_join: logo in assoc(c, :logo),
      preload: [:logo],
      limit: 1
  
    case Repo.one(query) do
      nil -> {:error, :not_found}
      company -> 
        url = company.logo
        |> Logo.url

        {:ok, %{company | logo: url}}
    end
  end

  def companyById(id) do
    Repo.one from c in Company,
      where: c.id == ^id,
      limit: 1
  end

  @spec update(UUID, map) :: {:ok, Company} | {:error, Changeset.t()}
  def update(id, params) do
    companyById(id)
    |> changeset(params)
    |> Repo.update
  end
end