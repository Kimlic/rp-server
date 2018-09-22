defmodule RpCore.Model.User do
  @moduledoc false

  use RpCore.Model

  ##### Schema #####

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "users" do
    field :first_name, :string, null: false
    field :last_name, :string, null: false

    belongs_to :role, Role

    timestamps()
  end

  @required_params ~w(first_name last_name role_id)a
  @optional_params ~w()a

  ##### Public #####

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
    |> foreign_key_constraint(:role_id, message: "Role should be selected")
  end
end