defmodule RpUaf.Fido.ClientBehaviour do
  # @callback create_request(binary) :: {:ok, map} | {:error, map}
  @callback reg_request(binary) :: {:ok, map} | {:error, map}
  @callback reg_response(term) :: {:ok, map} | {:error, map}
  @callback auth_request :: {:ok, map} | {:error, map}
  @callback auth_response(term) :: {:ok, map} | {:error, map}
end
