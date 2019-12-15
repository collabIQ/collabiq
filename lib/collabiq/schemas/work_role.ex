defmodule Collabiq.WorkRole do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Collabiq.{Agent, Query, Repo, Security, SiteWorkRole, UUID}

  @schema_name :work_role
  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "work_roles" do
    field(:description, :string)
    field(:name, :string)

    field(:tenant_id, :binary_id)

    timestamps(inserted_at: :created_at, type: :utc_datetime)

    has_many(:agents, Agent)
    has_many(:sites_work_roles, SiteWorkRole, on_replace: :delete)
  end

  ### Changesets ###
  @optional [:description]
  @required [:name]

  def cs(%__MODULE__{} = struct, attrs) do
    struct
    |> Repo.preload(:sites_work_roles)
    |> cast(attrs, @optional ++ @required)
    |> cast_sites_work_roles()
    |> validate_required(@required)
    |> foreign_key_constraint(:tenant_id)
  end

  defp cast_sites_work_roles(
         %{data: %{id: id, tenant_id: t_id}, params: %{"sites_work_roles" => sites_work_roles}} = cs
       ) do
    sites_work_roles =
      sites_work_roles
      |> Enum.map(fn x ->
        x
        |> Map.put(:tenant_id, t_id)
        |> Map.put(:work_role_id, id)
      end)
      |> Enum.map(&SiteWorkRole.cs/1)
      |> Enum.map(fn change ->
        case Repo.validate_change(change) do
          :ok ->
            apply_changes(change)

          _ ->
            []
        end
      end)
      |> List.flatten()

    put_assoc(cs, :sites_work_roles, sites_work_roles)
  end

  defp cast_sites_work_roles(cs), do: cs

  ### API Functions ###
  def create(attrs, sess) do
    with :ok <- Security.validate_perms(%{admin: [:create_work_role]}, sess),
         {:ok, id} <- UUID.string_gen(),
         change <- cs(%__MODULE__{id: id, tenant_id: sess.t_id}, attrs),
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
             %{admin: [:create_work_role, :manage_work_role, :purge_work_role]},
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
             %{admin: [:create_work_role, :manage_work_role, :purge_work_role]},
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

    with :ok <- Security.validate_perms(%{admin: [:manage_work_role]}, sess),
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
    with :ok <- Security.validate_perms(%{admin: [:purge_work_role]}, sess),
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
