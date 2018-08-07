defmodule RpKimcore.Schemes.Attestator do
  @moduledoc false

  use RpKimcore.Schemes

  ##### Schema #####

  @primary_key false
  embedded_schema do
    field :name, :string
    field :address, :string
  end

  ##### Public #####

  def changeset(%Attestator{} = struct, attrs) do
    fields = __MODULE__.__schema__(:fields)

    struct
    |> cast(attrs, fields)
    |> validate_required(fields)
  end
end