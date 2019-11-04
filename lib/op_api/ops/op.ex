defmodule OpApi.Ops.Op do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:txid, :string, []}
  schema "ops" do
    field :hash, :string
    field :ref, :string
    
    field :function, :string
    field :name, :string
    field :address, :string
    field :meta, :map

    field :confirmed, :boolean
    field :blk_i, :integer
    field :blk_t, :integer
    field :tx_i, :integer
  end

  @doc false
  def changeset(op, attrs) do
    op
    |> cast(attrs, [:txid, :hash, :ref, :function, :name, :address, :meta, :confirmed, :blk_i, :blk_t, :tx_i])
  end
end
