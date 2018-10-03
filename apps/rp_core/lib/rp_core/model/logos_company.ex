defmodule RpCore.Model.LogosCompany do
  @moduledoc false
  
  use RpCore.Model
  use RpCore.Uploader

  alias __MODULE__

  ##### Schema #####

  @derive {Jason.Encoder, except: [:__meta__, :company]}
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "logos_companys" do
    field :file, File.Type, null: false

    belongs_to :company, Company

    timestamps()
  end

  @required_params ~w(file company_id)a
  @optional_params ~w()a

  ##### Public #####

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
    |> cast_attachments(params, [:file], allow_paths: true)
    |> foreign_key_constraint(:company_id, message: "Should reference a company")
  end

  def url(model) do
    case model do
      nil -> nil
      model ->
        {model.file, model}
        |> File.url
    end
  end

  def logo_url do
    query = from l in LogosCompany,
      limit: 1

    case Repo.one(query) do
      nil -> {:error, :not_found}
      logo -> {:ok, LogosCompany.url(logo)}
    end
  end

  def create_logo(file, company_id) do
    params = %{
      file: file,
      company_id: company_id
    }
    
    %LogosCompany{}
    |> LogosCompany.changeset(params)
    |> Repo.insert
  end

  def delete_all, do: Repo.delete_all(LogosCompany)
end