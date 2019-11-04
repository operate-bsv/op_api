defmodule OpApi.Ops do
  @moduledoc """
  The Ops context.
  """

  import Ecto.Query, warn: false
  alias OpApi.Repo

  alias OpApi.Ops.Op

  @doc """
  Returns the list of ops.

  ## Examples

      iex> list_ops()
      [%Op{}, ...]

  """
  def list_ops(params \\ %{})

  def list_ops(%{"refs" => refs}) when is_list(refs) do
    Op
    |> distinct(:name)
    |> where(fragment("ARRAY[txid, hash, ref] && ?::varchar[]", ^refs))
    |> order_by([f], desc_nulls_last: [f.blk_i, f.tx_i])
    |> Repo.all
  end

  def list_ops(%{"refs" => refs}) when is_binary(refs) do
    list_ops(%{"refs" => String.split(refs, ",")})
  end

  def list_ops(_params) do
    Op
    |> distinct(:name)
    |> order_by([f], desc_nulls_last: [f.blk_i, f.tx_i])
    |> Repo.all
  end

  @doc """
  Gets a single op.

  Raises `Ecto.NoResultsError` if the Op does not exist.

  ## Examples

      iex> get_op!(123)
      %Op{}

      iex> get_op!(456)
      ** (Ecto.NoResultsError)

  """
  def get_op!(reference, params \\ %{})

  def get_op!(txid, %{"by" => "txid"}) do
    Op
    |> Repo.get_by!(txid: txid)
  end

  def get_op!(<<hash::binary-size(64)>>, _params) do
    Op
    |> where([f], f.hash == ^hash)
    |> Repo.get_by!(hash: hash)
  end

  def get_op!(ref, _params) do
    Op
    |> Repo.get_by!(ref: ref)
  end

  @doc """
  TODOC
  """
  def op_exists?(ref) do
    Op
    |> where([f], f.ref == ^ref)
    |> Repo.exists?
  end

  @doc """
  Creates a op.

  ## Examples

      iex> create_op(%{field: value})
      {:ok, %Op{}}

      iex> create_op(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_op(attrs \\ %{}) do
    %Op{}
    |> Op.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  TODOC
  """
  def insert_ops(entries) do
    opts = [
      on_conflict: :replace_all_except_primary_key,
      conflict_target: :txid
    ]
    Op
    |> Repo.insert_all(entries, opts)
  end

  @doc """
  Updates a op.

  ## Examples

      iex> update_op(op, %{field: new_value})
      {:ok, %Op{}}

      iex> update_op(op, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_op(%Op{} = op, attrs) do
    op
    |> Op.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Op.

  ## Examples

      iex> delete_op(op)
      {:ok, %Op{}}

      iex> delete_op(op)
      {:error, %Ecto.Changeset{}}

  """
  def delete_op(%Op{} = op) do
    Repo.delete(op)
  end

  @doc """
  TODOC
  """
  def delete_ops_from(tape_end) do
    Op
    |> where([f], f.blk_i > ^tape_end)
    |> Repo.delete_all
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking op changes.

  ## Examples

      iex> change_op(op)
      %Ecto.Changeset{source: %Op{}}

  """
  def change_op(%Op{} = op) do
    Op.changeset(op, %{})
  end
end
