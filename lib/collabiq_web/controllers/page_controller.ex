defmodule CollabiqWeb.PageController do
  use CollabiqWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
