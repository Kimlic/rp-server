defmodule RpCore.Model.Document do
  @moduledoc false
  
  use RpCore.Model

  ##### Schema #####

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "documents" do
    field :user_address, :string, null: false
    field :session_tag, :string, null: false
    field :type, :string, null: false
    
    has_many :photos, Photo, foreign_key: :document_id, on_delete: :delete_all

    timestamps()
  end

  @required_params ~w(user_address session_tag type)a
  @optional_params ~w()a

  ##### Public #####

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
    |> unique_constraint(:documents_user_address_type_index, name: :documents_user_address_type_index, message: "Document already exists")
  end
end