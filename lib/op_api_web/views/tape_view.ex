defmodule OpApiWeb.TapeView do
  use OpApiWeb, :view

  def render("show.json", %{result: result}) do
    %{data: result}
  end

  def render("error.json", %{error: error}),
    do: %{error: error}
end
