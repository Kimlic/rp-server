defmodule RpCore.Server.MediaServer do
  @moduledoc false

  use GenServer

  alias RpCore.Server.MediaRegistry

  ##### Public #####

  def start_link(_args_init, [document: document, session_id: _] = args) do
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

  def get_session_id(session_tag) do
    via_tuple(session_tag)
    |> GenServer.call(:get_session_id)
  end

  ##### Private #####

  def whereis(name: name) do
    MediaRegistry.whereis_name({:media_server, name})
  end

  @impl true
  def init(document: document, session_id: session_id) do
    state = %{document: document, session_id: session_id, photos: []}
    {:ok, state}
  end

  @impl true
  def handle_call(:get_state, _from, state), do: {:reply, {:ok, state}, state}
  def handle_call(:get_session_id, _from, state), do: {:reply, {:ok, state[:session_id]}, state}

  @impl true
  def handle_cast({:push_photo, photo: photo}, %{photos: photos} = state) do
    new_photos = photos ++ [photo]
    new_state = %{state | photos: new_photos}

    {:noreply, new_state}
  end

  defp via_tuple(name), do: {:via, MediaRegistry, {:media_server, name}}
end