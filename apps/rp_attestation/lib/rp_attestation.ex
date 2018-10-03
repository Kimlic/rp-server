defmodule RpAttestation do
  @moduledoc false

  @pool :ap_pool

  ##### Public #####

  @spec vendors() :: {:ok, map} | {:error, binary}
  def vendors, do: ap_vendors() |> get

  @spec session_create(binary, binary, binary, binary, binary, binary) :: {:ok, binary} | {:error, binary}
  def session_create(first_name, last_name, document_type, contract_address, device_os, device_token) do
    params = %{
      first_name: first_name, 
      last_name: last_name, 
      lang: "en",
      document_type: document_type, 
      contract_address: contract_address, 
      timestamp: "#{:os.system_time(:seconds)}",
      device_os: device_os, 
      device_token: device_token
    }

    res = ap_session_create()
    |> post(params)

    case res do
      {:ok, %{"data" => %{"session_id" => session_id}}} -> {:ok, session_id}
      {:ok, %{"error" => %{"message" => reason}}} -> {:error, reason}
      {:error, reason} -> {:error, reason}
    end
  end

  @spec photo_upload(binary, binary, binary, binary) :: :ok | {:error, binary}
  def photo_upload(session_id, country, media_type, file) do
    params = %{
      country: country,
      context: media_type,
      timestamp: "#{:os.system_time(:seconds)}",
      content: file
    }
    
    res = ap_session_create()
    |> Kernel.<>(session_id)
    |> Kernel.<>("/media")
    |> post(params)

    case res do
      {:ok, %{"data" => %{"status" => "ok"}}} -> :ok
      {:ok, %{"error" => %{"invalid" => [%{"rules" => [%{"description" => reason}]}]}}} -> {:error, reason}
      {:error, reason} -> {:error, reason}
    end
  end

  @spec verification_info(binary) :: {:ok, map} | {:error, binary} | {:error, atom}
  def verification_info(session_tag) do
    res = ap_verification_info()
    |> Kernel.<>("/#{session_tag}")
    |> get

    case res do
      {:ok, %{"status" => "not_found"}} -> {:error, :not_found}
      {:ok, %{"person" => %{}, "document" => %{}} = info} -> {:ok, info}
      {:error, reason} -> {:error, reason}
    end
  end

  ##### Private #####

  defp get(endpoint) do
    ap_endpoint()
    |> Kernel.<>(endpoint)
    |> RpHttp.get(@pool)
  end
 
  defp post(endpoint, params) do
    ap_endpoint()
    |> Kernel.<>(endpoint)
    |> RpHttp.post(params, @pool)
  end

  defp ap_endpoint, do: env(:ap_endpoint)

  defp ap_vendors, do: env(:ap_vendors)

  defp ap_session_create, do: env(:ap_session_create)

  defp ap_verification_info, do: env(:ap_verification_info)

  defp env(param), do: Application.get_env(:rp_attestation, param)
end
