defmodule RpKimcore do
  @moduledoc false

  alias RpKimcore.Schema.Config
  alias RpKimcore.Server.ConfigServer

  ##### Public #####

  @spec config() :: {:ok, Config.t()}
  def config, do: ConfigServer.config()
end
