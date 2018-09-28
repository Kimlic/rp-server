defmodule RpCore.Model.Document do
  @moduledoc false
  
  use RpCore.Model

  alias RpCore.Mapper.Veriff

  ##### Schema #####

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "documents" do
    field :user_address, :string, null: false
    field :session_tag, :string, null: false
    field :type, :string, null: false
    field :first_name, :string, null: false
    field :last_name, :string, null: false
    field :country, :string, null: false
    field :verified_at, Timex.Ecto.DateTime, usec: false
    field :verified, :boolean, null: false, default: true
    
    has_many :photos, Photo, foreign_key: :document_id, on_delete: :delete_all

    timestamps()
  end

  @required_params ~w(user_address session_tag type first_name last_name country)a
  @optional_params ~w(verified_at verified)a

  ##### Public #####

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
    |> unique_constraint(:documents_user_address_type_index, name: :documents_user_address_type_index, message: "Document already exists")
  end

  def all do
    query = from d in Document,
      order_by: [desc: d.inserted_at]
    
    Repo.all(query)
    |> Enum.map(fn doc -> 
      %Document{doc | type: Veriff.document_quorum_to_human(doc.type)}
    end)
  end

  def find_one_by(user_address, type) do
    query = from d in Document,
      where: d.user_address == ^user_address,
      where: d.type == ^type,
      limit: 1

    case Repo.one(query) do
      nil -> {:error, :not_found}
      document_id -> {:ok, document_id}
    end
  end

  def delete!(session_tag) do
    query = from d in Document,
      where: d.session_tag == ^session_tag,
      limit: 1
      
    Repo.one!(query)
    |> Repo.delete!
  end 
end