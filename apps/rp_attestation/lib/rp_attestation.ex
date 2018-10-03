defmodule RpAttestation do
  @moduledoc false

  alias RpAttestation.Server.VendorServer
  alias RpAttestation.DataProvider

  ##### Public #####

  @spec vendors() :: {:ok, map} | {:error, binary}
  def vendors, do: VendorServer.vendors()

  @spec session_create(binary, binary, binary, binary, binary, binary) :: {:ok, binary} | {:error, binary}
  def session_create(first_name, last_name, document_type, contract_address, device_os, device_token) do
    DataProvider.session_create(first_name, last_name, document_type, contract_address, device_os, device_token)
  end

  @spec photo_upload(binary, binary, binary, binary) :: :ok | {:error, binary}
  def photo_upload(session_id, country, media_type, file) do
    DataProvider.photo_upload(session_id, country, media_type, file)
  end

  @spec verification_info(binary) :: {:ok, map} | {:error, binary} | {:error, atom}
  def verification_info(session_tag), do: DataProvider.verification_info(session_tag)
end
