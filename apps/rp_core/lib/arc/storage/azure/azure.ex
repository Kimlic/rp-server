defmodule Arc.Storage.Azure do
  @moduledoc false

  ##### Public #####

  @spec put(__MODULE__, binary, {binary, binary}) :: {:ok, binary} | {:error, Plug.Conn.t}
  def put(definition, version, {file, scope}) do
    destination_dir = definition.storage_dir(version, {file, scope})
    case upload_file(destination_dir, file) do
      {:ok, _conn} -> {:ok, file.file_name}
      {:error, conn} -> {:error, conn}
    end
  end

  @spec url(__MODULE__, binary, {binary, binary}, list) :: Path.t
  def url(definition, version, file_and_scope, options \\ []) do
    temp_url_expires_after = Keyword.get(options, :temp_url_expires_after, default_tempurl_ttl())
    temp_url_filename = Keyword.get(options, :temp_url_filename, :false)
    temp_url_inline = Keyword.get(options, :temp_url_inline, :true)
    temp_url_method = Keyword.get(options, :temp_url_method, "GET")

    options = options
    |> Keyword.delete(:signed)
    |> Keyword.merge([
      temp_url_expires_after: temp_url_expires_after,
      temp_url_filename: temp_url_filename,
      temp_url_inline: temp_url_inline,
      temp_url_method: temp_url_method
      ]
    )
    build_url(definition, version, file_and_scope, options)
  end

  @spec delete(__MODULE__, binary, {binary, :nil | binary}) :: :ok
  def delete(_definition, _version, {file, :nil}) do
    server_object = parse_objectname_from_url(file.file_name)
    ExAzure.request!(:delete_blob, [container(), server_object])
    :ok
  end
  def delete(definition, version, {file, scope}) do
    server_object = build_path(definition, version, {file, scope})
    ExAzure.request!(:delete_blob, [container(), server_object])
    :ok
  end

  @spec default_tempurl_ttl :: number
  def default_tempurl_ttl do
    Application.get_env(:arc, :default_tempurl_ttl, (30 * 24 * 60 * 60))
  end

  ##### Private #####

  @spec host :: binary
  defp host, do: Application.get_env(:rp_core, :azure_cdn_url) <> "/" <> container()

  @spec build_path(__MODULE__, binary, {binary, binary}) :: Path.t
  defp build_path(definition, version, file_and_scope) do
    destination_dir = definition.storage_dir(version, file_and_scope)
    filename = Arc.Definition.Versioning.resolve_file_name(definition, version, file_and_scope)
    Path.join([destination_dir, filename])
  end

  @spec build_url(__MODULE__, binary, {binary, binary}, Keyword) :: Path.t
  defp build_url(definition, version, file_and_scope, _options) do
    Path.join(host(), build_path(definition, version, file_and_scope))
  end

  @spec parse_objectname_from_url(binary) :: binary
  defp parse_objectname_from_url(url) do
    [_host, server_object] = String.split(url, "#{host()}/")
    server_object
  end

  @spec upload_file(binary, binary) :: binary
  defp upload_file(destination_dir, file) do
    filename = Path.join(destination_dir, file.file_name)
    %Arc.File{content_type: content_type} = file

    case content_type do
      nil -> ExAzure.request(:put_block_blob, [container(), filename, get_binary_file(file)])
      content_type -> ExAzure.request(:put_block_blob, [container(), filename, get_binary_file(file), [content_type: content_type |> to_charlist]])
    end
  end

  @spec get_binary_file(map) :: binary
  defp get_binary_file(%{path: nil} = file), do: file.binary
  defp get_binary_file(%{path: _} = file), do: File.read!(file.path)

  @spec container :: binary
  defp container, do: Application.get_env(:rp_core, :azure_container)
end