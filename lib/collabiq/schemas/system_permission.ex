defmodule Collabiq.SystemPermission do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:create_directory, :boolean, default: false)
    field(:create_proxy, :boolean, default: false)
    field(:create_role, :boolean, default: false)
    field(:create_site, :boolean, default: false)
    field(:manage_directory, :boolean, default: false)
    field(:manage_proxy, :boolean, default: false)
    field(:manage_role, :boolean, default: false)
    field(:manage_site, :boolean, default: false)
    field(:manage_tenant, :boolean, default: false)
    field(:purge_directory, :boolean, default: false)
    field(:purge_proxy, :boolean, default: false)
    field(:purge_role, :boolean, default: false)
    field(:purge_site, :boolean, default: false)
    field(:purge_tenant, :boolean, default: false)
  end

  @attrs [
    :create_directory,
    :create_proxy,
    :create_role,
    :create_site,
    :manage_directory,
    :manage_proxy,
    :manage_role,
    :manage_site,
    :manage_tenant,
    :purge_directory,
    :purge_proxy,
    :purge_role,
    :purge_site,
    :purge_tenant
  ]

  def cs(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @attrs)
    |> validate_required(@attrs)
  end
end
