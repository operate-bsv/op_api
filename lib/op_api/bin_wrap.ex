defmodule OpApi.BinWrap do

  defstruct [:value]

  def wrap(val) when is_map(val) do
    Enum.reduce(val, %{}, fn({k,v}, map) -> Map.put(map, k, wrap(v)) end)
  end

  def wrap(val) when is_list(val) do
    Enum.map(val, &(wrap(&1)))
  end

  def wrap(val) when is_binary(val) do
    struct(__MODULE__, value: val)
  end

  def wrap(val), do: val
  
end


defimpl Jason.Encoder, for: [OpApi.BinWrap] do
  def encode(struct, opts) do
    cond do
      String.valid?(struct.value) -> Jason.Encode.string(struct.value, opts)
      true -> Base.encode64(struct.value) |> Jason.Encode.string(opts)
    end
  end
end