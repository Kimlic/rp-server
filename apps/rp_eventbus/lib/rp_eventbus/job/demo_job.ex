defmodule RpEventbus.Job.DemoJob do
    @moduledoc false
    
    use TaskBunny.Job
  
    @spec perform(map) :: :ok | {:error, term}
    def perform(%{}) do
        :timer.sleep(10_000)
        {:ok, status: "sent"}
    end
    def perform(_), do: :error
  
    @spec max_retry :: integer
    def max_retry, do: 5
  
    @spec retry_interval(integer) :: integer
    def retry_interval(failed_count) do
      [1, 10, 20, 40, 60]
      |> Enum.map(&(&1 * 1000))
      |> Enum.at(failed_count - 1, 1000)
    end

    def on_reject(_), do: :reject
end  