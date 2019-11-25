defmodule Collabiq.Security do
  alias Collabiq.Error

  def validate_perms(key, %{perms: perms}) do
    if perms[key] do
      :ok
    else
      Error.message(:user, :auth, :auth)
    end
  end

  def validate_perms(keys, %{system_perm: system_perm}) when is_list(keys) do
    if Enum.any?(keys, fn x -> system_perm[x] end) do
      :ok
    else
      Error.message(:user, :auth, :auth)
    end
  end

  def validate_perms(key, %{system_perm: system_perm}) do
    if system_perm[key] do
      :ok
    else
      Error.message(:user, :auth, :auth)
    end
  end

  def validate_perms(_, _), do: Error.message(:user, :auth, :auth)
end
