defmodule RpUaf.Model.Registration do
  @moduledoc false

  use RpUaf.Model
  
  import Ecto.Changeset

  @required_fields ~w(
    authenticator_id
    account_address
  )a

  @optional_fileds ~w(
    public_key
    sign_counter
    authenticator_version
    tc_display_png_characteristics
    user_id
    device_id
    time_stamp
    status
    attest_cert
    attest_data_to_sign
    attest_signature
    attest_verified_status
  )a

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "registrations" do
    field(:authenticator_id, Ecto.UUID)
    field(:public_key, :string)
    field(:sign_counter, :string)
    field(:authenticator_version, :string)
    field(:tc_display_png_characteristics, :string)
    field(:account_address, :string)
    field(:user_id, :string)
    field(:device_id, :string)
    field(:time_stamp, :string)
    field(:status, :string)
    field(:attest_cert, :string)
    field(:attest_data_to_sign, :string)
    field(:attest_signature, :string)
    field(:attest_verified_status, :string)

    timestamps()
  end

  @spec changeset(map) :: Ecto.Changeset.t()
  def changeset(params) when is_map(params), do: changeset(%__MODULE__{}, params)

  @spec changeset(__MODULE__, :invalid | map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = entity, params \\ :invalid) do
    entity
    |> cast(params, @required_fields ++ @optional_fileds)
    |> validate_required(@required_fields)
  end
end
 