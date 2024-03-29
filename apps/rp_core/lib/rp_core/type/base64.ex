defmodule RpCore.Type.Base64 do
  @moduledoc false

  @behaviour Ecto.Type

  @spec type :: atom
  def type, do: :string

  @spec cast(binary) :: {:ok, binary} | :error
  def cast(string) when is_binary(string), do: Base.decode64(string)
  def cast(_), do: :error

  @spec load(binary) :: {:ok, binary} | :error
  def load(string) when is_binary(string), do: {:ok, string}
  def load(_), do: :error

  @spec dump(term) :: {:ok, binary} | :error
  def dump(string) when is_binary(string), do: {:ok, string}
  def dump(_), do: :error
end
