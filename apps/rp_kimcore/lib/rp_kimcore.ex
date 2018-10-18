defmodule RpKimcore do
  @moduledoc false

  alias RpKimcore.Server.ConfigServer

  ##### Public #####

  defdelegate config, to: ConfigServer

  @spec veriff :: binary
  def veriff do
    {:ok, conf} = config()
    Enum.fetch!(conf.attestation_parties, 0).address
  end
end
