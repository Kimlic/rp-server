defmodule RpUaf.Repo.Migrations.CreateRegistrationsTable do
  use Ecto.Migration

  def change do
    create table :registrations, primary_key: false, prefix: "rp_uaf" do
      add :id, :uuid, primary_key: true, default: fragment("gen_random_uuid()")
      add :authenticator_id, :uuid, null: false
      add :public_key, :string, null: false
      add :account_address, :string, null: false
      add :user_id, :string, null: false
      add :device_id, :string, null: false
      add :sign_counter, :string, null: true
      add :time_stamp, :string, null: false, size: 20
      add :authenticator_version, :string, null: false
      add :tc_display_png_characteristics, :string, null: true
      add :status, :string, null: false
      add :attest_cert, :string, null: false, size: 1024
      add :attest_data_to_sign, :string, null: false, size: 1024
      add :attest_signature, :string, null: false
      add :attest_verified_status, :string, null: false, size: 20
      add :inserted_at, :naive_datetime, default: fragment("now()")
      add :updated_at, :naive_datetime, default: fragment("now()")
    end
  end
end
