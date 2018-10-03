defmodule RpAttestation.Application do
  @moduledoc false

  use Application

  alias RpAttestation.Server.VendorServer

  ##### Public #####

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(VendorServer, [[]], restart: :permanent)
    ]
    opts = [strategy: :one_for_one, name: RpAttestation.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
