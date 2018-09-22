defmodule RpCore.Model.Role do
  @moduledoc false

  use RpCore.Model

  ##### Schema #####

  schema "roles" do
    field :name, :string, null: false

    has_many :users, User, foreign_key: :role_id, on_delete: :nothing
  end

  @required_params ~w(name)a
  @optional_params ~w()a

  ##### Public #####

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
  end

end