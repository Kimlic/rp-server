defmodule RpUaf.Fido.Request do
  @moduledoc false

  import Ecto.Query, only: [select: 3, where: 3, limit: 2]

  alias RpUaf.Repo
  alias RpUaf.Model.{Registration, ScopeRequest}
  alias RpUaf.Fido.Client

  @type scope_request :: ScopeRequest.t()

  ##### Public #####

  @spec get!(binary) :: scope_request
  def get!(id), do: Repo.get!(ScopeRequest, id)

  @spec create(map) :: {:ok, scope_request} | {:error, binary}
  def create(attrs) do
    %ScopeRequest{}
    |> ScopeRequest.changeset(attrs)
    |> Repo.insert()
  end

  @spec update(scope_request, map) :: {:ok, scope_request} | {:error, term}
  def update(%ScopeRequest{} = schema, attrs) do
    schema
    |> ScopeRequest.changeset(attrs)
    |> Repo.update()
  end

  @spec check_processed(scope_request) :: :ok | {:error, :scope_request_already_processed}
  def check_processed(%ScopeRequest{used: true}), do: {:error, :scope_request_already_processed}
  def check_processed(%ScopeRequest{used: false}), do: :ok

  @spec check_expired(scope_request) :: :ok | {:error, :scope_request_expired}
  def check_expired(%ScopeRequest{inserted_at: inserted_at}) do
    expires_at = Application.get_env(:rp_uaf, :scope_request_ttl)
    |> Kernel.+(:os.system_time(:second))
    |> DateTime.from_unix!()

    case DateTime.compare(expires_at, inserted_at) do
      :lt -> {:error, :scope_request_expired}
      _ -> :ok
    end
  end

  @spec process(scope_request, binary) :: {:ok, scope_request} | {:error, binary}
  def process(%ScopeRequest{} = scope_request, account_address) do
    update(scope_request, %{used: true, account_address: account_address})
  end

  @spec create_request(binary) :: {:ok, map} | {:error, tuple}
  def create_request(account_address) do
    case account_registered?(account_address) do
      true -> Client.auth_request
      false -> Client.reg_request(account_address)
    end
  end

  def account_registered?(account_address) do
    Registration
    |> select([r], r.account_address)
    |> where([r], r.account_address == ^account_address)
    |> limit(1)
    |> Repo.all()
    |> case do
      [] -> false
      [_] -> true
    end
  end
end
