defmodule OpApi.RefGenerator do
  use GenServer
  alias Postgrex.Notifications
  alias OpApi.Repo
  alias OpApi.Ops
  alias OpApi.Ops.Op

  @event_name "new_op"

  def start_link(args \\ [], opts \\ []) do
    GenServer.start_link(__MODULE__, args, opts)
  end

  def init(_args \\ []) do
    with {:ok, pid} <- Notifications.start_link(Repo.config),
         {:ok, ref} <- Notifications.listen(pid, @event_name) do
      {:ok, {pid, @event_name, ref}}
    else
      error -> {:stop, error}
    end
  end

  def handle_info({:notification, _pid, _ref, @event_name, message}, _state) do
    with {:ok, payload} <- Jason.decode(message, keys: :atoms),
         {:ok, hash} <- Base.decode16(payload.data.hash, case: :lower)
    do
      struct(%Op{}, payload.data)
      |> Ops.update_op(%{ref: get_hash_ref(hash, 4)})
      {:noreply, :event_handled}
    else
      error -> {:stop, error, []}
    end
  end

  def handle_info(_, _state), do: {:noreply, :event_received}

  defp get_hash_ref(hash, bytes) do
    <<id::bytes-size(bytes), _rest::bytes>> = hash
    id = Base.encode16(id, case: :lower)
    if Ops.op_exists?(id) do
      get_hash_ref(hash, bytes+1)
    else
      id
    end
  end
end