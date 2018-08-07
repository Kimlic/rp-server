defmodule RpUaf.Fido.Qr do
  @moduledoc false

  alias RpUaf.Fido.Request
  alias RpUaf.Model.ScopeRequest

  @type process_scope_request_response ::
    {:ok, %{scope_request: ScopeRequest.t(), fido: map}}
    | {:error, :scope_request_already_processed}
    | {:error, :scope_request_expired}

  ##### Public #####

  @spec create_scope_request :: %ScopeRequest{}
  def create_scope_request do
    Request.create(%{
      scopes: fetch_scopes(),
      status: ScopeRequest.status(:new),
      used: false
    })
  end

  @spec process_scope_request(ScopeRequest.t(), binary) :: process_scope_request_response
  def process_scope_request(%ScopeRequest{} = scope_request, account_address) when is_binary(account_address) do
    with :ok <- Request.check_processed(scope_request),
    :ok <- Request.check_expired(scope_request),
    {:ok, processed_scope_request} <- Request.process(scope_request, account_address),
    {:ok, fido} <- Request.create_request(account_address) do
      {:ok, %{
        scope_request: processed_scope_request,
        fido: fido
      }}
    end
  end

  @spec process_scope_request(binary, binary) :: process_scope_request_response
  def process_scope_request(id, account_address) when is_binary(id) do
    Request.get!(id)
    |> process_scope_request(account_address)
  end

  @spec generate_qr_code(binary) :: binary
  def generate_qr_code(%ScopeRequest{id: id}) do
    Application.get_env(:rp_uaf, :callback_url)
    |> Kernel.<>("?scope_request=#{id}")
    |> QRCode.to_png()
  end

  ##### Private #####

  @spec fetch_scopes :: binary
  defp fetch_scopes do
    Application.get_env(:rp_uaf, :requested_scopes)
    |> Enum.join(" ")
  end
end