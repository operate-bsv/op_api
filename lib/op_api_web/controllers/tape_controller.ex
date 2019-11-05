defmodule OpApiWeb.TapeController do
  use OpApiWeb, :controller

  action_fallback OpApiWeb.FallbackController

  def show(conn, %{"id" => id}) do
    with {:ok, tape} <- Operate.load_tape(id),
         {:ok, tape} <- Operate.run_tape(tape)
    do
      render(conn, "show.json", result: OpApi.BinWrap.wrap(tape.result))
    else
      {:error, tape} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("show.json", error: tape.error)
    end
  end

end
