defmodule OpApiWeb.Router do
  use OpApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OpApiWeb do
    pipe_through :api

    resources "/ops", OpController, only: [:index, :show]
    get "/ops/:id/fn", OpController, :function
    get "/ops/:id/versions", OpController, :versions

    resources "/tapes", TapeController, only: [:show]
    post "/tapes/:id", TapeController, :run

    get "/woc/tape/inspect", TapeController, :show
    get "/woc/tape/run", TapeController, :run
  end
end
