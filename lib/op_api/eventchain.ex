defmodule OpApi.Eventchain do
  use GenServer
  require Logger

  # GenServer API
  def start_link(args \\ [], opts \\ []) do
    GenServer.start_link(__MODULE__, args, opts)
  end

  def init(args) do
    handler = Keyword.get(args, :handler)
    wrapper = Application.app_dir(:op_api, "priv/bin/wrapper")
    port = Port.open({:spawn_executable, wrapper}, [
      :binary,
      args: ["echain", "pipe", "-s", Jason.encode!(handler.config)]
    ])
    Port.monitor(port)

    {:ok, %{port: port, handler: handler, latest_output: nil, exit_status: nil}}
  end

  # This callback handles data incoming from the command's STDOUT
  def handle_info({port, {:data, text_line}}, %{port: port} = state) do
    latest_output = text_line |> String.trim
    state.handler.parse_message(latest_output)

    {:noreply, %{state | latest_output: latest_output}}
  end

  # This callback tells us when the process exits
  def handle_info({port, {:exit_status, status}}, %{port: port} = state) do
    Logger.info "EventChain exit: :exit_status: #{status}"
    {:noreply, %{state | exit_status: status}}
  end

  def handle_info({:DOWN, _ref, :port, port, :normal}, state) do
    Logger.info "Handled :DOWN message from port: #{inspect port}"
    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.info "Unhandled message: #{inspect msg}"
    {:noreply, state}
  end
end