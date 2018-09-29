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

  def count_documents do
    query = "
      select t1.date_at, coalesce(t2.verified, 0) as verified, coalesce(t3.unverified, 0) as unverified from (
        select date(d.inserted_at) as date_at
        from rp_core.documents as d
        group by date(d.inserted_at)
      ) as t1
      left join (
        select count(d.id) as verified, date(d.inserted_at) as date_at
        from rp_core.documents as d
        where not d.verified
        group by date(d.inserted_at)
      ) as t2
      on t2.date_at = t1.date_at
      left join (
        select count(d.id) as unverified, date(d.inserted_at) as date_at
        from rp_core.documents as d
        where d.verified
        group by date(d.inserted_at)
      ) as t3
      on t3.date_at = t1.date_at
      order by date_at;
    "
    res = Ecto.Adapters.SQL.query!(Repo, query, [])
    roles = Enum.map res.rows, fn(row) ->
      date = row
      |> Enum.at(0)
      |> Date.from_erl
      |> elem(1)

      %{
        date_at: date, 
        verified: Enum.at(row, 1), 
        unverified: Enum.at(row, 2)
      }
    end

    roles
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