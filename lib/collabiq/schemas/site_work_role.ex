defmodule Collabiq.SiteWorkRole do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Collabiq.{Site, WorkRole}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sites_work_roles" do
    embeds_one :perms, Perm, [on_replace: :delete, primary_key: false] do
      field(:create_group, :boolean, default: false)
      field(:manage_group, :boolean, default: false)
      field(:purge_group, :boolean, default: false)
      field(:create_ou, :boolean, default: false)
      field(:manage_ou, :boolean, default: false)
      field(:purge_ou, :boolean, default: false)
      field(:create_user, :boolean, default: false)
      field(:manage_user, :boolean, default: false)
      field(:purge_user, :boolean, default: false)
    end

    field(:tenant_id, :binary_id)

    belongs_to(:site, Site)
    belongs_to(:work_role, WorkRole)
  end

  ### Changesets ###
  @perms_optional [
    :create_group,
    :manage_group,
    :purge_group,
    :create_ou,
    :manage_ou,
    :purge_ou,
    :create_user,
    :manage_user,
    :purge_user
  ]
  @required [:site_id, :tenant_id, :work_role_id]

  def cs(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> cast_embed(:perms, with: &perms_cs/2)
    |> foreign_key_constraint(:site_id)
    |> foreign_key_constraint(:tenant_id)
    |> foreign_key_constraint(:work_role_id)
  end

  def perms_cs(%__MODULE__.Perm{} = struct, attrs) do
    struct
    |> cast(attrs, @perms_optional)
  end
end
