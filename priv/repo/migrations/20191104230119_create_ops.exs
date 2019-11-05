defmodule OpApi.Repo.Migrations.CreateOps do
  use Ecto.Migration

  def change do
    create table(:ops, primary_key: false) do
      add :txid, :string, primary_key: true
      add :hash, :string, null: false
      add :ref, :string

      add :fn, :text
      add :name, :string
      add :addr, :string
      add :meta, :map

      add :conf, :boolean, default: false
      add :blk_i, :integer
      add :blk_t, :integer
      add :tx_i, :integer
    end

    create index(:ops, [:hash])
    create index(:ops, [:ref], unique: true)
    create index(:ops, [:name])
    create index(:ops, [:addr])
    create index(:ops, [:blk_i, :tx_i])
  end
end
