defmodule RpKimcore do
  @moduledoc false

  alias RpKimcore.Schema.Config
  alias RpKimcore.Server.ConfigServer

  ##### Public #####

  @spec config() :: {:ok, Config.t()}
  def config, do: ConfigServer.config()

  def veriff do
    {:ok, conf} = config()
    Enum.fetch!(conf.attestation_parties, 0).address
  end
end
