defmodule Collabiq.Security do
  alias Collabiq.Error

  def validate_perms(key, %{perms: perms}) do
    if perms[key] do
      :ok
    else
      Error.message(:user, :auth, :auth)
    end
  end

  def validate_perms(perms, sess, site_id \\ nil)

  def validate_perms(%{admin: keys} = perms, %{admin_perms: admin_perms} = sess, site_id) do
    if Enum.any?(keys, fn x -> admin_perms[x] end) do
      :ok
    else
      perms = Map.drop(perms, [:admin])
      sess = Map.drop(sess, [:admin_perms])
      validate_perms(perms, sess, site_id)
    end
  end

  def validate_perms(%{work: keys}, sess, site_id) do
    case sess do
      %{:work_perms => %{^site_id => work_perms}} ->
        if Enum.any?(keys, fn x -> work_perms[x] end) do
          :ok
        else
          Error.message(:user, :auth, :auth)
        end
      _ ->
        Error.message(:user, :auth, :auth)
    end
  end

  def validate_perms(_, _, _), do: Error.message(:user, :auth, :auth)

  def validate_systems_perms(keys, %{system_perm: system_perm}) when is_list(keys) do
    if Enum.any?(keys, fn x -> system_perm[x] end) do
      :ok
    else
      Error.message(:user, :auth, :auth)
    end
  end

  def validate_systems_perms(key, %{system_perm: system_perm}) do
    if system_perm[key] do
      :ok
    else
      Error.message(:user, :auth, :auth)
    end
  end

  def validate_systems_perms(_, _), do: Error.message(:user, :auth, :auth)
end
