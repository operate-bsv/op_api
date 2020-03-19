defmodule OpApiWeb.TapeController do
  use OpApiWeb, :controller

  action_fallback OpApiWeb.FallbackController

  @doc """
  Loads and renders tape for inspection
  """
  def show(conn, %{"id" => id}) do
    with {:ok, tape} <- Operate.load_tape(id) do
      render(conn, "show.json", result: tape.cells)
    else
      {:error, err} ->
        conn
        |> put_status(:not_found)
        |> render("error.json", error: err)
    end
  end

  # Fallthrough
  def show(conn, %{} = params),
    do: show(conn, %{"id" => normalize_id(params)})
  

  @doc """
  Loads, executes and renders tape result
  """
  def run(conn, %{"id" => id}) do
    with {:ok, tape} <- Operate.load_tape(id),
         {:ok, tape} <- Operate.run_tape(tape)
    do
      render(conn, "show.json", result: OpApi.BinWrap.wrap(tape.result))
    else
      {:error, tape} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", error: tape.error)
    end
  end

  # Fallthrough
  def run(conn, %{} = params),
    do: run(conn, %{"id" => normalize_id(params)})


  # Normalizes txid and vout into single string
  defp normalize_id(%{} = params) do
    id = [
      get_in(params, ["txid"]),
      get_in(params, ["vout"])
    ]
    |> Enum.reject(&is_nil/1)
    |> Enum.join("/")
  end

end
