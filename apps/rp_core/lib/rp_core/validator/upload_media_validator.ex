defmodule RpCore.Validator.UploadMediaValidator do
  @moduledoc false

  use RpCore.Model

  alias RpCore.Type.Base64

  ##### Schema #####

  @primary_key false
  embedded_schema do
    field :file, Base64
  end

  ##### Public #####

  @spec changeset(map) :: Ecto.Changeset.t()
  def changeset(params \\ %{}) do
    fields = __MODULE__.__schema__(:fields)

    %__MODULE__{}
    |> cast(params, fields)
    |> validate_required(fields)
  end
end
