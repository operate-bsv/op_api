defmodule OpApiWeb.TapeView do
  use OpApiWeb, :view

  def render("show.json", %{result: result}) do
    %{data: result}
  end

  def render("show.json", %{error: error}) do
    %{data: error}
  end
end
