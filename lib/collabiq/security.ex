defmodule Collabiq.Security do
  alias Collabiq.Error

  def validate_perms(key, %{perms: perms}) do
    if perms[key] do
      :ok
    else
      Error.message(:user, :auth, :auth)
    end
  end

  def validate_perms(_, _), do: Error.message(:user, :auth, :auth)
end
