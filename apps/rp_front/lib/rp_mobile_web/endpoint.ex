defmodule RpFrontWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :rp_front

  socket "/socket", RpFrontWeb.UserSocket, websocket: []

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger, level: Logger.level()

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  plug Plug.MethodOverride
  plug Plug.Head
  
  plug RpFrontWeb.Router

  def init(_key, config) do
    if config[:load_from_system_env] do
      port = config[:http][:port] || raise "expected the RP_FRONT_PORT environment variable to be set"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
