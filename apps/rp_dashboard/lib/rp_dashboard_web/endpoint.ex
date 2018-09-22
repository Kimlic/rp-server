defmodule RpDashboardWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :rp_dashboard

  socket "/socket", RpDashboardWeb.UserSocket, websocket: []

  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger, level: Logger.level()

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
    pass: ["*/*"],
    json_decoder: Jason

  plug Plug.MethodOverride
  plug Plug.Head

  plug Corsica, 
    max_age: 600, 
    origins: "*", 
    allow_headers: ~w(accept x-auth-token content-type origin authorization), 
    allow_credentials: true

  plug RpDashboardWeb.Router

  def init(_key, config) do
    if config[:load_from_system_env] do
      port = config[:http][:port] || raise "expected the RP_DASHBOARD_PORT environment variable to be set"
      {:ok, Keyword.put(config, :http, [:inet6, port: port])}
    else
      {:ok, config}
    end
  end
end
