defmodule RpCore.Model.Document do
  @moduledoc false
  
  use RpCore.Model

  alias RpCore.Mapper

  ##### Schema #####

  @derive {Jason.Encoder, only: [:first_name, :last_name, :verified_at, :status, :reason, :type, :country]}
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "documents" do
    field :user_address, :string, null: false
    field :session_tag, :string, null: false
    field :type, :string, null: false
    field :first_name, :string, null: false
    field :last_name, :string, null: false
    field :country, :string
    field :status, :string
    field :reason, :string
    field :verified_at, :naive_datetime
    
    has_many :photos, Photo, foreign_key: :document_id, on_delete: :delete_all
    belongs_to :attestator, Attestator

    timestamps()
  end

  @required_params ~w(user_address session_tag type first_name last_name attestator_id)a
  @optional_params ~w(verified_at status reason country)a

  ##### Public #####

  @spec changeset(__MODULE__, map | :invalid) :: Ecto.Changeset.t
  def changeset(%__MODULE__{} = model, params \\ :invalid) do
    model
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
    |> unique_constraint(:documents_user_address_type_index, name: :documents_user_address_type_index, message: "Document already exists")
    |> foreign_key_constraint(:attestator_id, message: "Should reference an attestator")
  end

  @spec all() :: {:ok, list(__MODULE__)}
  def all do
    query = from d in Document,
      order_by: [desc: d.inserted_at]
    
    documents = Repo.all(query)
    |> prettify_types
    
    {:ok, documents}
  end

  def session_tags do
    query = from d in Document,
      select: [:session_tag]
    
    res = Repo.all(query)
    |> Enum.map(fn doc -> doc.session_tag end)

    {:ok, res}
  end

  @spec get_by_id(UUID) :: {:ok, __MODULE__} | {:error, :not_found}
  def get_by_id(id) do
    query = from d in Document,
      left_join: p in assoc(d, :photos),
      preload: [:photos],
      where: d.id == ^id,
      limit: 1

    case Repo.one(query) do
      nil -> {:error, :not_found}
      document -> 
        photos = photos_to_urls(document)
        type = document.type
        |> Mapper.Veriff.document_quorum_to_human

        {:ok, %Document{document | photos: photos, type: type}}
    end
  end

  @spec documents_by_user_address(binary) :: {:ok, list(__MODULE__)} | {:error, :not_found}
  def documents_by_user_address(user_address) do
    query = from d in Document,
      where: ilike(d.user_address, ^user_address)

    case Repo.all(query) do
      nil -> {:error, :not_found}
      documents -> 
        documents = documents
        |> Enum.map(fn doc -> 
          %Document{doc | type: Mapper.Veriff.document_quorum_to_veriff(doc.type)}
        end)
        {:ok, documents}
    end
  end

  @spec count_documents :: {:ok, map}  
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
        where d.verified_at is not null
        group by date(d.inserted_at)
      ) as t2
      on t2.date_at = t1.date_at
      left join (
        select count(d.id) as unverified, date(d.inserted_at) as date_at
        from rp_core.documents as d
        where d.verified_at is null
        group by date(d.inserted_at)
      ) as t3
      on t3.date_at = t1.date_at
      order by date_at;
    "
    res = Ecto.Adapters.SQL.query!(Repo, query, [])
    count = Enum.map(res.rows, fn(row) ->
      date = row
      |> Enum.at(0)
      |> Date.from_erl
      |> elem(1)

      %{
        date_at: date, 
        verified: Enum.at(row, 1), 
        unverified: Enum.at(row, 2)
      }
    end)
    {:ok, count}
  end

  @spec find_one_by(binary, binary) :: {:ok, __MODULE__} | {:error, :not_found}
  def find_one_by(user_address, type) do
    query = from d in Document,
      where: d.user_address == ^user_address,
      where: d.type == ^type,
      limit: 1

    case Repo.one(query) do
      nil -> {:error, :not_found}
      document -> {:ok, document}
    end
  end

  @spec create(binary, binary, UUID, binary, binary, binary, Attestator) :: {:ok, __MODULE__} | {:error, Ecto.Changeset.t}
  def create(user_address, doc_type, session_tag, first_name, last_name, country, attestator) do
    params = %{
      user_address: user_address,
      type: doc_type,
      session_tag: session_tag,
      first_name: first_name, 
      last_name: last_name, 
      country: country,
      attestator_id: attestator.id
    }

    %Document{}
    |> Document.changeset(params)
    |> Repo.insert
  end

  # %{
  #   "document" => %{
  #     "country" => nil, 
  #     "number" => nil, 
  #     "type" => "DRIVERS_LICENSE", 
  #     "validFrom" => nil, 
  #     "validUntil" => nil
  #   }, 
  #   "person" => %{
  #     "citizenship" => nil, 
  #     "dateOfBirth" => nil, 
  #     "firstName" => "Vladimir", 
  #     "gender" => nil, 
  #     "idNumber" => nil, 
  #     "lastName" => "Babenko", 
  #     "nationality" => nil
  #   }, 
  #   "reason" => "Client did not use a physical document. ", 
  #   "status" => "declined"
  # }
  @spec assign_verification(__MODULE__, nil | map) :: {:ok, __MODULE__} :: {:error, Ecto.Changeset.t}
  def assign_verification(document, %{"status" => "approved"} = info) do
    %{"document" => verified_document, "person" => person} = info
    %{"firstName" => first_name, "lastName" => last_name} = person
    %{"country" => country} = verified_document

    params = %{
      first_name: first_name,
      last_name: last_name,
      country: country,
      status: "approved",
      reason: nil,
      verified_at: NaiveDateTime.utc_now()
    }
  
    document
    |> Document.changeset(params)
    |> Repo.update
  end
  def assign_verification(%__MODULE__{} = document, %{"status" => status, "reason" => reason}) when status in ["resubmission_requested", "declined"] do
    params = %{
      status: status,
      reason: reason,
      verified_at: NaiveDateTime.utc_now()
    }

    document
    |> Document.changeset(params)
    |> Repo.update
  end
  def assign_verification(%__MODULE__{} = document, nil) do
    params = %{
      status: "approved",
      reason: nil,
      verified_at: NaiveDateTime.utc_now()
    }

    document
    |> Document.changeset(params)
    |> Repo.update
  end

  @spec delete!(UUID) :: {:ok, __MODULE__} | {:error, :not_found}
  def delete!(session_tag) do
    query = from d in Document,
      where: d.session_tag == ^session_tag,
      limit: 1
      
    case Repo.one(query) do
      nil -> {:error, :not_found}
      document -> Repo.delete(document)
    end
  end 

  ##### Private #####

  @spec prettify_types(list(__MODULE__)) :: list(__MODULE__)
  defp prettify_types(documents) do
    documents
    |> Enum.map(fn doc -> 
      type = doc.type
      |> Mapper.Veriff.document_quorum_to_human

      %Document{doc | type: type}
    end)
  end

  @spec photos_to_urls(__MODULE__) :: list(map)
  defp photos_to_urls(document) do
    document.photos
    |> Enum.map(fn photo -> 
      %{
        url: Photo.url(photo),
        type: photo.type
      }
    end)
  end
end