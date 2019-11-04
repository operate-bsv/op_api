defmodule OpApi.OpsTest do
  use OpApi.DataCase

  alias OpApi.Ops

  describe "ops" do
    alias OpApi.Ops.Op

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def op_fixture(attrs \\ %{}) do
      {:ok, op} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Ops.create_op()

      op
    end

    test "list_ops/0 returns all ops" do
      op = op_fixture()
      assert Ops.list_ops() == [op]
    end

    test "get_op!/1 returns the op with given id" do
      op = op_fixture()
      assert Ops.get_op!(op.id) == op
    end

    test "create_op/1 with valid data creates a op" do
      assert {:ok, %Op{} = op} = Ops.create_op(@valid_attrs)
    end

    test "create_op/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ops.create_op(@invalid_attrs)
    end

    test "update_op/2 with valid data updates the op" do
      op = op_fixture()
      assert {:ok, %Op{} = op} = Ops.update_op(op, @update_attrs)
    end

    test "update_op/2 with invalid data returns error changeset" do
      op = op_fixture()
      assert {:error, %Ecto.Changeset{}} = Ops.update_op(op, @invalid_attrs)
      assert op == Ops.get_op!(op.id)
    end

    test "delete_op/1 deletes the op" do
      op = op_fixture()
      assert {:ok, %Op{}} = Ops.delete_op(op)
      assert_raise Ecto.NoResultsError, fn -> Ops.get_op!(op.id) end
    end

    test "change_op/1 returns a op changeset" do
      op = op_fixture()
      assert %Ecto.Changeset{} = Ops.change_op(op)
    end
  end
end
