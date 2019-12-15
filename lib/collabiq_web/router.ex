defmodule CollabiqWeb.Router do
  use CollabiqWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :graph do
    plug :accepts, ["json"]
    plug CollabiqWeb.AuthResolver, :graph
  end

  pipeline :rest do
    plug :accepts, ["json"]
    plug CollabiqWeb.AuthResolver, :rest
  end

  scope "/graphiql" do
    pipe_through :graph

    forward("/", Absinthe.Plug.GraphiQL,
      schema: CollabiqWeb.Schema,
      socket: CollabiqWeb.UserSocket
    )
  end

  scope "/graphql" do
    pipe_through :graph
    forward("/", Absinthe.Plug, schema: CollabiqWeb.Schema, socket: CollabiqWeb.UserSocket)
  end

  scope "/rest", CollabiqWeb do
    pipe_through :rest

    get "/directories", DirectoryController, :list
    get "/directories/:id", DirectoryController, :get
    post "/directories", DirectoryController, :create
    post "/directories/:id/delete", DirectoryController, :delete
    post "/directories/:id/disable", DirectoryController, :disable
    post "/directories/:id/enable", DirectoryController, :enable
    post "/directories/:id/purge", DirectoryController, :purge
    post "/directories/:id", DirectoryController, :update

    get "/proxies", ProxyController, :list
    get "/proxies/:id", ProxyController, :get
    post "/proxies", ProxyController, :create
    post "/proxies/:id/delete", ProxyController, :delete
    post "/proxies/:id/disable", ProxyController, :disable
    post "/proxies/:id/enable", ProxyController, :enable
    post "/proxies/:id/purge", ProxyController, :purge
    post "/proxies/:id", ProxyController, :update

    get "/sites", SiteController, :list
    get "/sites/:id", SiteController, :get
    post "/sites", SiteController, :create
    post "/sites/:id/delete", SiteController, :delete
    post "/sites/:id/disable", SiteController, :disable
    post "/sites/:id/enable", SiteController, :enable
    post "/sites/:id/purge", SiteController, :purge
    post "/sites/:id", SiteController, :update
  end

  scope "/", CollabiqWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", CollabiqWeb do
  #   pipe_through :api
  # end
end
