defmodule RpMobileWeb.Plug.RequestValidator do
  @moduledoc false

  use Phoenix.Controller

  import Plug.Conn

  alias RpMobileWeb.FallbackController
  alias Ecto.Changeset
  alias Plug.Conn

  ##### Public #####

  @spec init(Plug.opts()) :: Plug.opts()
  def init(opts), do: opts

  @spec call(Conn.t(), Plug.opts()) :: Conn.t()
  def call(%Conn{params: params} = conn, opts) do
    validator = fetch_validator!(opts)

    case validator.changeset(params) do
      %Changeset{valid?: true} = changeset -> assign(conn, :validated_params, Changeset.apply_changes(changeset))
      %Changeset{valid?: false} = changeset -> error_conn(conn, opts, changeset)
      result -> raise("Expected validator #{validator}.changeset/1 return %Ecto.Changeset{}, #{inspect(result)} given")
    end
  end

  ##### Private #####

  @spec error_conn(Conn.t(), Plug.opts(), Changeset.t()) :: Conn.t()
  defp error_conn(conn, opts, changeset) do
    err_handler = fetch_error_handler(opts)

    conn
    |> err_handler.call(changeset)
    |> halt()
  end

  @spec fetch_validator!(Plug.opts()) :: module
  defp fetch_validator!(opts), do: fetch!(opts, :validator)

  @spec fetch_error_handler(Plug.opts()) :: module
  defp fetch_error_handler(opts), do: opts[:error_handler] || FallbackController

  @spec fetch!(Plug.opts(), atom) :: module
  defp fetch!(opts, key) do
    case Keyword.get(opts, key) do
      nil -> raise_error(key)
      handler -> handler
    end
  end

  @spec raise_error(atom) :: no_return
  defp raise_error(key), do: raise("Config `#{key}` is missing for #{__MODULE__}")
end
