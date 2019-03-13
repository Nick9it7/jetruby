defmodule JetrubyWeb.Router do
  use JetrubyWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", JetrubyWeb do
    pipe_through :api

    get "/repositories/sync", GithubController, :sync
    get "/repositories", GithubController, :index
  end
end
