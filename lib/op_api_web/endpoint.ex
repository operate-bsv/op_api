defmodule OpApiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :op_api


  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    if config[:load_from_system_env] do
      host = Application.get_env(:op_api, :app_host) || raise "expected the APP_HOST environment variable to be set"
      port = Application.get_env(:op_api, :app_port) || raise "expected the APP_PORT environment variable to be set"
      port = String.to_integer(port)
      scheme = if port == 443, do: "https", else: "http"

      config = config
      |> Keyword.put(:url, [scheme: scheme, host: host, port: port])
      {:ok, config}
    else
      {:ok, config}
    end
  end


  socket "/socket", OpApiWeb.UserSocket,
    websocket: true,
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :op_api,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_op_api_key",
    signing_salt: "w8bl9W2+"

  # Disable CORS
  plug Corsica, origins: "*"

  plug OpApiWeb.Router
end
