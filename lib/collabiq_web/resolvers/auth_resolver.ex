defmodule CollabiqWeb.AuthResolver do
  import Plug.Conn

  alias Collabiq.{Auth, Error}
  alias Phoenix.Token
  alias CollabiqWeb.Endpoint

  @user_salt "4C1yLc1v"

  def init(opts) do
    opts
  end

  def call(conn, opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, session_id} <- verify(token),
         {:ok, session} <- Collabiq.get_session(session_id) do
      conn
      |> Absinthe.Plug.put_options(context: %{session: session})
      |> assign(:context, %{session: session})
    else
      _ ->
        case opts do
          :rest ->
            CollabiqWeb.AuthMiddleware.halt(conn, 401)
          _ ->
            Absinthe.Plug.put_options(conn, context: %{session: %{}})
        end
    end
  end

  def verify(token) do
    case Token.verify(Endpoint, @user_salt, token, max_age: 2_592_000) do
      {:ok, session_id} ->
        {:ok, session_id}

      _ ->
        Error.message(:token, :invalid, :login)
    end
  end

  def login(args, _) do
    with {:ok, session} <- Auth.login(args),
         token <- sign(session) do
      {:ok, %{token: token}}
    else
      error ->
        error
    end
  end

  def sign(%{id: session_id}) do
    Token.sign(Endpoint, @user_salt, session_id, max_age: 2_592_000)
  end
end
