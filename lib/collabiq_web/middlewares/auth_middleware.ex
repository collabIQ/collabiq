defmodule CollabiqWeb.AuthMiddleware do
  @behaviour Absinthe.Middleware

  alias Collabiq.Error

  def call(res, _config) do
    case res.context.session do
      %{id: _, t_id: _, u_id: _} ->
        res

      _ ->
        res
        |> Absinthe.Resolution.put_result(Error.message(:login, :invalid, :login))
    end
  end

  def halt(conn, code \\ 401) do
    conn
      |> Plug.Conn.put_status(code)
      |> Phoenix.Controller.put_view(CollabiqWeb.ErrorView)
      |> Phoenix.Controller.render("#{code}.json")
      |> halt()
  end
end
