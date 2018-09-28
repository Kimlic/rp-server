defmodule RpUaf.Model.ScopeRequest do
  @moduledoc false

  use RpUaf.Model

  import Ecto.Changeset

  @status_new "NEW"

  @required ~w(status scopes)a
  @optional ~w(account_address used)a

  ##### Scheme #####

  @derive {Jason.Encoder, except: [:__meta__]}
  @primary_key {:id, :binary_id, autogenerate: true}
  schema "scope_requests" do
    field :status, :string, null: false, default: @status_new
    field :scopes, :string, null: false
    field :used, :boolean, default: false
    field :account_address, :string

    timestamps(type: :utc_datetime)
  end

  ##### Public #####

  @spec status(atom) :: charlist
  def status(:new), do: @status_new

  @spec changeset(ScopeRequest.t(), map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = schema, attrs) do
    schema
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end
end
