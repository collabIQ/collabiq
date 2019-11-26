defmodule CollabiqWeb.Router do
  use CollabiqWeb, :router

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

  scope "/graphiql" do
    pipe_through([:api])
    forward("/", Absinthe.Plug.GraphiQL, schema: CollabiqWeb.Schema, socket: CollabiqWeb.UserSocket)
  end

  forward("/graphql", Absinthe.Plug, schema: CollabiqWeb.Schema)

  scope "/", CollabiqWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", CollabiqWeb do
  #   pipe_through :api
  # end
end
