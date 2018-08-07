defmodule RpEventbus do
  @moduledoc false

  def rabbit_job do
    # res = %{ data: data, meta: meta }
    # |> RpEventbus.Jobs.DemoJob.enqueue!

    res = TaskBunny.Job.enqueue!(RpEventbus.Job.DemoJob, %{})

    IO.inspect "RABBIT RES: #{res}"
    :ok
end
end
