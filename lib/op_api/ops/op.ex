defmodule OpApi.Ops.Op do
  use Ecto.Schema
  import Ecto.Changeset
  alias OpApi.Ops

  @primary_key {:txid, :string, []}
  schema "ops" do
    field :hash, :string
    field :ref, :string

    field :fn, :string
    field :name, :string
    field :addr, :string
    field :meta, :map

    field :conf, :boolean
    field :blk_i, :integer
    field :blk_t, :integer
    field :tx_i, :integer
  end

  @doc false
  def changeset(op, attrs) do
    op
    |> cast(attrs, [:txid, :hash, :ref, :fn, :name, :addr, :meta, :conf, :blk_i, :blk_t, :tx_i])
  end

  def from_bob(attrs) do
    Enum.find(attrs["out"], &op_return_output?/1)
    |> Map.get("tape")
    |> Enum.find(&operate_cell?/1)
    |> cell_to_map
    |> Map.merge(%{
      txid: attrs["tx"]["h"],
      addr: attrs["in"] |> List.first |> get_in(["e", "a"]),
      conf: Map.has_key?(attrs, "blk"),
      blk_i: get_in(attrs, ["blk", "i"]),
      blk_t: get_in(attrs, ["blk", "t"]),
      tx_i: attrs["i"]
    })
    |> put_short_ref
  end

  defp op_return_output?(out) do
    out["tape"] |> List.first |> op_return_cell?
  end

  defp op_return_cell?(%{"cell" => cell}) do
    Enum.any?(cell, &(&1["op"] == 106))
  end

  defp operate_cell?(%{"cell" => [protocol | _tail]}) do
    protocol["s"] == "1PcsNYNzonE39gdZkvXEdt7TKBT5bXQoz4"
  end

  defp cell_to_map(%{"cell" => [_p, function, name | _t]}) do
    func = function["s"] || function["d"]
    hash = :crypto.hash(:sha256, func) |> Base.encode16(case: :lower)
    meta = parse_comment_tags(func)
    %{
      hash: hash,
      fn: func,
      name: name["s"],
      meta: meta
    }
  end

  defp parse_comment_tags(func) do
    comments = Regex.scan(~r/\A--\[\[(.+)\]\]--/s, func) |> List.flatten |> Enum.at(1, "")
    for [_m, key, value] <- Regex.scan(~r/^\@(\w+)\s+(.+)$/m, comments), into: %{} do
      {key, value}
    end
  end


  defp put_short_ref(%{txid: txid, hash: hash} = attrs, bytes \\ 4) do
    len = bytes * 2
    <<ref::binary-size(len), _::binary>> = hash

    case Ops.unique_ref?(ref, txid) do
      true -> Map.put(attrs, :ref, ref)
      false -> put_short_ref(attrs, bytes+1)
    end
  end

end
