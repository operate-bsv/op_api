defmodule OpApiWeb.PageController do
  use OpApiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
