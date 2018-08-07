defmodule RpCore.Model.Photo do
  @moduledoc false
  
  use RpCore.Model
  use RpCore.Uploader

  ##### Schema #####

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "photos" do
    field :file, File.Type, null: false
    field :account_address, :string, null: false

    timestamps()
  end

  @required_params ~w(file account_address)a
  @optional_params ~w()a

  ##### Public #####

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
    |> cast_attachments(params, [:file], allow_paths: true)
  end

  def url(model) do
    {model.file, model}
    |> File.url
  end
end