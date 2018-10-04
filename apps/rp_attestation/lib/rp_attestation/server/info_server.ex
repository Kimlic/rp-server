defmodule RpAttestation.Server.InfoServer do
  use GenServer

  alias RpAttestation.DataProvider

  ##### Public #####

  @spec start_link(list) :: {:ok, pid} | {:error, binary}
  def start_link(_), do: GenServer.start_link(__MODULE__, nil, name: __MODULE__)

  @spec verification_info(binary) :: {:ok, list}
  def verification_info(session_tag), do: GenServer.call(__MODULE__, {:verification_info, session_tag})

  ##### Callbacks #####

  @impl true
  def init(_) do
    {:ok, %{verification: %{}}}
  end

  @impl true
  def handle_call({:verification_info, session_tag}, from, %{verification: verification} = state) do
    with {:ok, info} <- Map.fetch(verification, session_tag) do
      {:reply, {:ok, info}, state}
    else
      :error -> 
        owner = self()

        spawn fn ->
          fetch_info(session_tag, from, owner)
        end

        {:noreply, state}
    end
  end
  def handle_call(_, _, state), do: {:noreply, state}

  @impl true
  def handle_cast({:save_info, session_tag, info}, %{verification: verification} = state) do
    new_verification = verification
    |> Map.put(session_tag, info)

    {:noreply, %{state | verification: new_verification}}
  end
  def handle_cast(_, state), do: {:noreply, state}

  ##### Private #####

  defp fetch_info(session_tag, from, owner) do
    session_tag
    |> DataProvider.verification_info
    |> case do
      {:error, :not_found} -> GenServer.reply(from, :not_found)
      {:ok, %{"document" => _, "person" => _} = info} -> 
        GenServer.reply(from, {:ok, info})
        GenServer.cast(owner, {:save_info, session_tag, info})
    end 
  end
end