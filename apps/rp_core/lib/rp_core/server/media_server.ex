defmodule RpCore.Server.MediaServer do
  @moduledoc false

  use GenServer

  alias RpCore.Server.MediaRegistry

  ##### Public #####

  def start_link(args_init, [document: document] = args) do
    IO.inspect "MEDIA SERVER STARTING: #{inspect args_init}   #{inspect args}"
    GenServer.start_link(__MODULE__, args, name: via_tuple(document.session_tag))
  end

  def push_photo(session_tag, photo) do
    via_tuple(session_tag)
    |> GenServer.cast({:push_photo, photo: photo})
  end

  def get_state(session_tag) do
    via_tuple(session_tag)
    |> GenServer.call(:get_state)
  end

  ##### Private #####

  def whereis(name: name) do
    IO.inspect "WHEREIS: #{inspect name}"
    MediaRegistry.whereis_name({:media_server, name})
  end

  @impl true
  def init(document: document) do
    state = %{document: document, photos: []}
    IO.inspect "SERVER INITED: #{inspect state}"
    {:ok, state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:push_photo, photo: photo}, %{photos: photos} = state) do
    IO.inspect "SERVER CURRENT STATE: #{inspect state}"
    new_photos = photos ++ [photo]
    new_state = %{state | photos: new_photos}
    IO.inspect "SERVER NEW STATE: #{inspect new_state}"

    {:noreply, new_state}
  end

  defp via_tuple(name), do: {:via, MediaRegistry, {:media_server, name}}
end