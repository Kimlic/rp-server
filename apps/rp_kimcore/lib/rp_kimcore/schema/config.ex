defmodule RpKimcore.Schema.Config do
  @moduledoc false

  use RpKimcore.Schema

  ##### Schema #####

  @primary_key false
  embedded_schema do
    field :context_contract, :string, null: false
    embeds_many :attestation_parties, Attestator
  end

  @required_fields ~w(context_contract)a

  ##### Public #####

  def changeset(params) when is_map(params) do
    %__MODULE__{}
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> cast_embed(:attestation_parties)
  end
end
