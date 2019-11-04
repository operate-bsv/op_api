defmodule OpApiWeb.OpView do
  use OpApiWeb, :view
  alias OpApiWeb.OpView

  def render("index.json", %{ops: ops, params: params}) do
    data = case params do
      %{"script" => _} -> render_many(ops, OpView, "op_full.json")
      _ -> render_many(ops, OpView, "op_meta.json")
    end

    %{data: data}
  end

  def render("show.json", %{op: op, params: params}) do
    data = case params do
      %{"script" => _} -> render_one(op, OpView, "op_full.json")
      _ -> render_one(op, OpView, "op_meta.json")
    end

    %{data: data}
  end

  def render("op_meta.json", %{op: op}) do
    %{
      txid: op.txid,
      hash: op.hash,
      ref: op.ref,
      name: op.name,
      address: op.address,
      confirmed: op.confirmed,
      meta: op.meta,
      blk: %{
        i: op.blk_i,
        t: op.blk_t
      },
      i: op.tx_i
    }
  end

  def render("op_full.json", %{op: op}) do
    render("op_meta.json", %{op: op})
    |> Map.put(:function, op.function)
  end
end
