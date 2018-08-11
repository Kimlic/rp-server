defmodule RpCore.Model.Photo do
  @moduledoc false
  
  use RpCore.Model
  use RpCore.Uploader

  ##### Schema #####

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "photos" do
    field :file, File.Type, null: false
    field :file_hash, :string, null: false
    field :type, :string, null: false

    belongs_to :document, Document

    timestamps()
  end

  @required_params ~w(file file_hash type document_id)a
  @optional_params ~w()a

  ##### Public #####

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
    |> cast_attachments(params, [:file], allow_paths: true)
    |> unique_constraint(:file_hash, name: :photos_file_hash_index, message: "Photo already exists")
    |> foreign_key_constraint(:document_id, message: "Should reference a document")
  end

  def url(model) do
    {model.file, model}
    |> File.url
  end

  def find_one_by(file_hash) do
    query = from photo in Photo, 
      right_join: documents in assoc(photo, :document),
      preload: [:document],
      where: photo.file_hash == ^file_hash,
      limit: 1

    case RpCore.Repo.one(query) do
      nil -> {:error, :not_found}
      photo -> {:ok, photo}
    end
  end
end