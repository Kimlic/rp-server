defmodule RpCore.Model.Attestator do
  @moduledoc false

  use RpCore.Model

  ##### Schema #####

  @derive {Jason.Encoder, except: [:__meta__, :inserted_at, :updated_at]}
  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "attestators" do
    field :name, :string, null: false
    field :cost_per_user, :float, null: false, default: 0.0
    field :compliance, {:array, :string}
    field :response, Ecto.Interval
    field :rating, :integer, null: false, default: 0
    field :status, :boolean, null: false, default: true

    has_one :logo, LogosAttestator, foreign_key: :attestator_id, on_delete: :delete_all

    timestamps()
  end

  @required_params ~w(name)a
  @optional_params ~w(cost_per_user compliance response rating status)a

  ##### Public #####

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_params ++ @optional_params)
    |> validate_required(@required_params)
  end

  def attestators do
    query = from a in Attestator,
      left_join: logo in assoc(a, :logo),
      preload: [:logo],
      order_by: [:name]

    Repo.all(query)
    |> Enum.map(&prepare_attestator/1)
  end

  ##### Private #####

  defp prepare_attestator(attestator) do
    compliance = attestator.compliance
      |> Enum.join(", ")

      cost = attestator.cost_per_user
      |> :erlang.float_to_binary([:compact, {:decimals, 10}])

      logo = case attestator.logo do
        nil -> nil
        logo -> LogosAttestator.url(logo)
      end

      %{attestator | compliance: compliance, cost_per_user: cost, logo: logo }
  end
end