defmodule Collabiq.AdminRole do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Collabiq.{Query, Repo, Security}

  @schema_name :system_role
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "admin_roles" do
    field(:description, :string)
    field(:name, :string)
    embeds_one :perms, Perm, [on_replace: :delete, primary_key: false] do
      field(:create_admin_role, :boolean, default: false)
      field(:manage_admin_role, :boolean, default: false)
      field(:purge_admin_role, :boolean, default: false)
      field(:create_agent, :boolean, default: false)
      field(:manage_agent, :boolean, default: false)
      field(:purge_agent, :boolean, default: false)
      field(:create_directory, :boolean, default: false)
      field(:manage_directory, :boolean, default: false)
      field(:purge_directory, :boolean, default: false)
      field(:create_proxy, :boolean, default: false)
      field(:manage_proxy, :boolean, default: false)
      field(:purge_proxy, :boolean, default: false)
      field(:create_site, :boolean, default: false)
      field(:manage_site, :boolean, default: false)
      field(:purge_site, :boolean, default: false)
      field(:manage_tenant, :boolean, default: false)
      field(:purge_tenant, :boolean, default: false)
      field(:create_work_role, :boolean, default: false)
      field(:manage_work_role, :boolean, default: false)
      field(:purge_work_role, :boolean, default: false)
    end

    field(:tenant_id, :binary_id)

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end

  ### Changesets ###
  @optional [:description]
  @perms_optional [
    :create_admin_role,
    :manage_admin_role,
    :purge_admin_role,
    :create_agent,
    :manage_agent,
    :purge_agent,
    :create_directory,
    :manage_directory,
    :purge_directory,
    :create_proxy,
    :manage_proxy,
    :purge_proxy,
    :create_site,
    :manage_site,
    :purge_site,
    :manage_tenant,
    :purge_tenant,
    :create_work_role,
    :manage_work_role,
    :purge_work_role
  ]
  @required [:name]

  def cs(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @optional ++ @required)
    |> validate_required(@required)
    |> cast_embed(:perms, with: &perms_cs/2)
    |> unique_constraint(:name, name: :systems_roles_tenant_id_name_index)
    |> foreign_key_constraint(:tenant_id)
  end

  def perms_cs(%__MODULE__.Perm{} = struct, attrs) do
    struct
    |> cast(attrs, @perms_optional)
  end

  ### API Functions ###
  def create(attrs, sess) do
    with :ok <- Security.validate_perms(%{admin: [:create_admin_role]}, sess),
         change <- cs(%__MODULE__{tenant_id: sess.t_id}, attrs),
         :ok <- Repo.validate_change(change),
         {:ok, struct} <- Repo.put(change) do
      {:ok, struct}
    else
      error ->
        error
    end
  end

  def delete(id, sess) do
    %{status: "deleted", deleted_at: Timex.now(), id: id}
    |> modify(sess)
  end

  def disable(id, sess) do
    %{status: "disabled", deleted_at: nil, id: id}
    |> modify(sess)
  end

  def enable(id, sess) do
    %{status: "active", deleted_at: nil, id: id}
    |> modify(sess)
  end

  def get(id, sess) do
    with :ok <-
           Security.validate_perms(
             %{admin: [:create_admin_role, :manage_admin_role, :purge_admin_role]},
             sess
           ),
         {:ok, struct} <-
           __MODULE__
           |> where([q], q.id == ^id)
           |> where([q], q.tenant_id == ^sess.t_id)
           |> Repo.one()
           |> Repo.validate_read(@schema_name) do
      {:ok, struct}
    else
      error ->
        error
    end
  end

  def list(attrs, sess) do
    with :ok <-
           Security.validate_perms(
             %{admin: [:create_admin_role, :manage_admin_role, :purge_admin_role]},
             sess
           ),
         {:ok, structs} <-
           __MODULE__
           |> where([q], q.tenant_id == ^sess.t_id)
           |> Query.filter(attrs, @schema_name)
           |> Query.sort(attrs, @schema_name)
           |> Repo.all()
           |> Repo.validate_read(@schema_name) do
      {:ok, structs}
    else
      error ->
        error
    end
  end

  defp modify(attrs, sess) do
    id = Map.get(attrs, "id") || Map.get(attrs, :id)

    with :ok <- Security.validate_perms(%{admin: [:manage_admin_role]}, sess),
         {:ok, struct} <- get(id, sess),
         change <- cs(struct, attrs),
         :ok <- Repo.validate_change(change),
         {:ok, struct} <- Repo.put(change) do
      {:ok, struct}
    else
      error ->
        error
    end
  end

  def purge(id, sess) do
    with :ok <- Security.validate_perms(%{admin: [:purge_system_role]}, sess),
         {:ok, struct} <- get(id, sess),
         change <- cs(struct, %{}),
         :ok <- Repo.validate_change(change),
         {:ok, struct} <- Repo.purge(change) do
      {:ok, struct}
    else
      error ->
        error
    end
  end

  def update(attrs, sess) do
    modify(attrs, sess)
  end
end
