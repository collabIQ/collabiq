defmodule Collabiq.Auth do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Collabiq.{Agent, Error, Repo}

  def get_login_by_email(email) do
    Agent
    |> where([q], q.email == ^email)
    |> where([q], q.status == ^"active")
    |> Repo.one()
    |> Repo.validate_read(:login)
  end

  def login(%{email: email, password: password}) do
    with {:ok, agent} <- get_login_by_email(email),
         :ok <- check_password(password, agent.pw),
         {:ok, session} <- Collabiq.create_session(agent) do
      {:ok, session}
    else
      error ->
        Bcrypt.no_user_verify()
        error
    end
  end

  def check_password(password, hash) do
    case Bcrypt.verify_pass(password, hash) do
      true ->
        :ok

      _ ->
        Error.message({:login, :invalid})
    end
  end
end
