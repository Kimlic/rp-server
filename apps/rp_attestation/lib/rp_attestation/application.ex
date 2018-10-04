defmodule RpAttestation.Application do
  @moduledoc false

  use Application

  alias RpAttestation.Server.{VendorServer, InfoServer}

  ##### Public #####

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(VendorServer, [[]], restart: :permanent),
      worker(InfoServer, [[]], restart: :permanent)
    ]
    opts = [strategy: :one_for_one, name: RpAttestation.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
