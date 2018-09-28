defmodule RpCore.Model.Logo do
  @moduledoc false
  
  use RpCore.Model
  use RpCore.Uploader

  alias __MODULE__

  ##### Schema #####

  @derive {Jason.Encoder, except: [:__meta__, :company]}
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "logos" do
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
    {model.file, model}
    |> File.url
  end

  def logo_url do
    query = from l in Logo,
      limit: 1

    case Repo.one(query) do
      nil -> {:error, :not_found}
      logo -> {:ok, Logo.url(logo)}
    end
  end

  def delete_all, do: Repo.delete_all(Logo)
end