defmodule RpKimcore.Schemes.Config do
  @moduledoc false

  use RpKimcore.Schemes

  ##### Schema #####

  @primary_key false
  embedded_schema do
    field :context_contract, :string
    embeds_many :attestation_parties, Attestator
  end

  ##### Public #####

  def changeset(params) when is_map(params) do
    fields = ~w(context_contract)a

    %__MODULE__{}
    |> cast(params, fields)
    |> cast_embed(:attestation_parties)
    |> validate_required(fields)
  end
  def changeset(_), do: :error
end
