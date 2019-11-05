defmodule OpApi.Operate.EctoAdapter do
  use Operate.Adapter
  alias OpApi.Ops

  def fetch_ops(refs, _opts \\ []) when is_list(refs) do
    functions = Ops.list_ops(%{"refs" => refs})
    |> Enum.map(&to_function/1)
    {:ok, functions}
  end

  defp to_function(%{} = r) do
    # Map.take(r, [:ref, :hash, :name, :fn])
    struct(Operate.Op, [
      ref: r.ref,
      hash: r.hash,
      name: r.name,
      script: r.fn
    ])
  end
  
end