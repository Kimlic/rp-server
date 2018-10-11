defmodule RpAttestation.DataProvider do
  @moduledoc false

  @pool :ap_pool

  ##### Public #####

  @spec vendors() :: {:ok, map} | {:error, binary}
  def vendors do
    res = ap_vendors() 
    |> get
    |> elem(1)
    # |> Map.fetch!("data")

    case res do
      :econnrefused -> {:error, :econnrefused}
      res -> {:ok, res}
    end
  end

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
  def photo_upload(media_type, session_id, country, file) do
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
      {:ok, %{"error" => %{"message" => reason}}} -> {:error, reason}
      {:error, reason} -> {:error, reason}
    end
  end

  @spec verification_info(binary) :: {:ok, map} | {:error, binary} | {:error, atom}
  def verification_info(session_id) do
    res = ap_verification_info()
    |> Kernel.<>("/#{session_id}")
    |> get

    case res do
      {:ok, %{"status" => "not_found"}} -> {:error, :not_found}
      {:ok, %{"person" => _, "document" => _, "status" => _, "reason" => _} = info} -> {:ok, info}
      {:error, reason} -> {:error, reason}
    end
  end

  ##### Private #####

  @spec get(binary) :: {:ok, map}
  defp get(endpoint) do
    ap_endpoint()
    |> Kernel.<>(endpoint)
    |> RpHttp.get(@pool)
  end

  @spec post(binary, map) :: {:ok, map}
  defp post(endpoint, params) do
    ap_endpoint()
    |> Kernel.<>(endpoint)
    |> RpHttp.post(params, @pool)
  end

  @spec ap_endpoint() :: binary
  defp ap_endpoint, do: env(:ap_endpoint)

  @spec ap_vendors() :: binary
  defp ap_vendors, do: env(:ap_vendors)

  @spec ap_session_create() :: binary
  defp ap_session_create, do: env(:ap_session_create)

  @spec ap_verification_info() :: binary
  defp ap_verification_info, do: env(:ap_verification_info)

  @spec env(binary) :: binary
  defp env(param), do: Application.get_env(:rp_attestation, param)
end