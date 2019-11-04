defmodule OpApiWeb.OpControllerTest do
  use OpApiWeb.ConnCase

  alias OpApi.Ops
  alias OpApi.Ops.Op

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  def fixture(:op) do
    {:ok, op} = Ops.create_op(@create_attrs)
    op
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all ops", %{conn: conn} do
      conn = get(conn, Routes.op_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create op" do
    test "renders op when data is valid", %{conn: conn} do
      conn = post(conn, Routes.op_path(conn, :create), op: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.op_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.op_path(conn, :create), op: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update op" do
    setup [:create_op]

    test "renders op when data is valid", %{conn: conn, op: %Op{id: id} = op} do
      conn = put(conn, Routes.op_path(conn, :update, op), op: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.op_path(conn, :show, id))

      assert %{
               "id" => id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, op: op} do
      conn = put(conn, Routes.op_path(conn, :update, op), op: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete op" do
    setup [:create_op]

    test "deletes chosen op", %{conn: conn, op: op} do
      conn = delete(conn, Routes.op_path(conn, :delete, op))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.op_path(conn, :show, op))
      end
    end
  end

  defp create_op(_) do
    op = fixture(:op)
    {:ok, op: op}
  end
end
