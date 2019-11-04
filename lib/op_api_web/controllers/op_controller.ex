defmodule OpApiWeb.OpController do
  use OpApiWeb, :controller

  alias OpApi.Ops

  action_fallback OpApiWeb.FallbackController

  def index(conn, params) do
    ops = Ops.list_ops(params)
    render(conn, "index.json", ops: ops, params: params)
  end

  def show(conn, %{"id" => id} = params) do
    op = Ops.get_op!(id, params)
    conn
    |> put_resp_header("cache-control", "public, max-age=#{ cache_expiry(op) }")
    |> render("show.json", op: op, params: params)
  end

  def function(conn, %{"id" => id} = params) do
    op = Ops.get_op!(id, params)
    conn
    |> put_resp_content_type("text/x-lua")
    |> put_resp_header("cache-control", "public, max-age=#{ cache_expiry(op) }")
    |> text(op.function)
  end

  defp cache_expiry(op) do
    case op.confirmed do
      true -> 31536000
      false -> 600
    end
  end
end
