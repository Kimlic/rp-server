defmodule RpMobileWeb.Plug.AccountAddress do
  @moduledoc false

  import Plug.Conn

  alias Plug.Conn

  @header "account-address"
  @address_regex ~r/^0x[0-9a-f]{40}$/

  @error_no_header "Account-Address header required"
  @error_malformed_header "Malformed Account-Address header format"

  ##### Public #####

  @spec init(Plug.opts()) :: Plug.opts()
  def init(opts), do: opts

  @spec call(Conn.t(), Plug.opts()) :: Conn.t()
  def call(%Conn{} = conn, _opts) do
    with {:ok, header} <- validate_required_header(conn),
    :ok <- validate_format(header) do
      assign(conn, :account_address, header)
    else
      {:error, err} -> no_header_error(conn, err)
      _ -> no_header_error(conn)
    end
  end

  ##### Private #####

  @spec validate_required_header(Conn.t()) :: {:ok, binary} | {:error, binary}
  defp validate_required_header(conn) do
    case Conn.get_req_header(conn, @header) do
      [header] -> {:ok, header}
      _ -> {:error, @error_no_header}
    end
  end

  @spec validate_format(binary) :: :ok | {:error, binary}
  defp validate_format(header) do
    case Regex.match?(@address_regex, header) do
      true -> :ok
      false -> {:error, @error_malformed_header}
    end
  end

  @spec no_header_error(Conn.t()) :: Conn.t()
  defp no_header_error(conn) do
    conn
    |> send_resp(:bad_request, @error_no_header)
    |> halt()
  end
  
  @spec no_header_error(Conn.t(), binary) :: Conn.t()
  defp no_header_error(conn, err) do
    conn
    |> send_resp(:bad_request, err)
    |> halt()
  end
end
