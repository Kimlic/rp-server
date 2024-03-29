defmodule RpAttestation do
  @moduledoc false

  alias RpAttestation.Server.{VendorServer}
  alias RpAttestation.DataProvider

  ##### Public #####

  @spec vendors() :: {:ok, map} | {:error, binary}
  def vendors, do: VendorServer.vendors()

  @spec session_create(binary, binary, binary, binary, binary, binary) :: {:ok, binary} | {:error, binary}
  def session_create(first_name, last_name, document_type, contract_address, device_os, device_token) do
    DataProvider.session_create(first_name, last_name, document_type, contract_address, device_os, device_token)
  end

  @spec photo_upload(binary, binary, binary, binary) :: :ok | {:error, binary}
  def photo_upload(media_type, session_id, country, file) do
    DataProvider.photo_upload(media_type, session_id, country, file)
  end

  @spec verification_info(binary) :: {:ok, map} | {:error, binary} | {:error, atom}
  def verification_info(session_id) do 
    session_id
    |> DataProvider.verification_info
    |> case do
      {:error, :not_found} -> {:error, :not_found}
      {:ok, %{"document" => _, "person" => _, "status" => _, "reason" => _} = info} -> {:ok, info}
    end 
  end
end
