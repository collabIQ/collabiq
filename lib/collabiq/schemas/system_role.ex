defmodule Collabiq.SystemRole do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Collabiq.{Directory, Query, Repo, Response, Security, SystemPermission, UUID}

  @schema_name :role
  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "systems_roles" do
    field(:description, :string)
    field(:name, :string)
    # field(:user_count, :integer, default: 0, virtual: true)

    field(:tenant_id, :binary_id)

    timestamps(inserted_at: :created_at, type: :utc_datetime)

    embeds_one(:permissions, SystemPermission, on_replace: :update)
  end

  ### Changesets ###
  @optional [:description]
  @required [:name]

  @spec cs(%__MODULE__{}, map()) :: {:ok, Ecto.Changeset.t()} | {:error, [any(), ...]}
  def cs(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @optional ++ @required)
    |> cast_embed(:permissions, required: true)
    |> validate_required(@required)
    |> unique_constraint(:name, name: :systems_roles_tenant_id_name_index)
    |> foreign_key_constraint(:tenant_id)
    |> Repo.validate_change()
  end

  ### API Functions ###
  def create(attrs, sess, opts \\ []) do
    with :ok <- Security.validate_perms(:create_system_role, sess),
         {:ok, id} <- UUID.string_gen(),
         {:ok, change} <- cs(%__MODULE__{id: id, tenant_id: sess.t_id}, attrs),
         {:ok, struct} <- Repo.put(change, opts),
         {:ok, response} <- Response.return(@schema_name, :create, struct) do
      {:ok, %{@schema_name => struct, :response => response}}
    else
      error ->
        error
    end
  end

  def delete(id, sess, opts \\ []) do
    %{status: "deleted", deleted_at: Timex.now(), id: id}
    |> modify(:delete, sess, opts)
  end

  def disable(id, sess, opts \\ []) do
    %{status: "disabled", deleted_at: nil, id: id}
    |> modify(:disable, sess, opts)
  end

  def enable(id, sess, opts \\ []) do
    %{status: "active", deleted_at: nil, id: id}
    |> modify(:enable, sess, opts)
  end

  def get(id, sess, opts \\ []) do
    with {:ok, id} <- UUID.validate_id(id),
         :ok <-
           Security.validate_perms(
             [:create_system_role, :manage_system_role, :purge_system_role],
             sess
           ),
         {:ok, struct} <-
           get_query(id, sess, opts)
           |> Repo.single(opts)
           |> Repo.validate_read(@schema_name) do
      {:ok, struct}
    else
      error ->
        error
    end
  end

  def get_query(id, sess, opts) do
    query =
      __MODULE__
      |> where([q], q.tenant_id == ^sess.t_id)
      |> where([q], q.id == ^id)

    Keyword.get(opts, :fields, [])
    |> Enum.any?(fn x -> x == "userCount" end)
    |> case do
      true ->
        query
        |> join(:left, [q], u in assoc(q, :users), as: :user_count)
        |> group_by([q], [
          q.id,
          q.description,
          q.name,
          q.notes,
          q.status,
          q.tenant_id,
          q.created_at,
          q.updated_at,
          q.deleted_at
        ])
        |> select_merge([q, u], %{user_count: count(u.id)})

      _ ->
        query
    end
  end

  def list(attrs, sess, opts \\ []) do
    query =
      __MODULE__
      |> where([q], q.tenant_id == ^sess.t_id)

    user_count =
      Keyword.get(opts, :fields, [])
      |> Enum.any?(fn x -> x == "userCount" end)

    query =
      case user_count do
        true ->
          query
          |> join(:left, [q], u in assoc(q, :users), as: :user_count)
          |> group_by([q], [
            q.id,
            q.description,
            q.name,
            q.notes,
            q.status,
            q.created_at,
            q.updated_at,
            q.deleted_at
          ])
          |> select_merge([q, u], %{user_count: count(u.id)})

        _ ->
          query
      end

    with :ok <-
           Security.validate_perms(
             [:create_system_role, :manage_system_role, :purge_system_role],
             sess
           ),
         {:ok, structs} <-
           query
           |> Query.filter(attrs, @schema_name)
           |> Query.sort(attrs, @schema_name)
           |> Repo.full()
           |> Repo.validate_read(@schema_name) do
      {:ok, structs}
    else
      error ->
        error
    end
  end

  defp modify(attrs, body, sess, opts) do
    with :ok <- Security.validate_perms(:manage_system_role, sess),
         {:ok, struct} <- get(attrs, sess, id: :binary_id),
         {:ok, change} <- cs(struct, attrs),
         {:ok, struct} <- Repo.put(change, opts),
         {:ok, response} <- Response.return(@schema_name, body, struct) do
      {:ok, %{@schema_name => struct, :response => response}}
    else
      error ->
        error
    end
  end

  def purge(id, sess, opts \\ []) do
    with {:ok, id} <- UUID.validate_id(id),
         :ok <- Security.validate_perms(:purge_system_role, sess),
         {:ok, struct} <- get(id, sess, id: :binary_id),
         {:ok, change} <- cs(struct, %{}),
         {:ok, struct} <- Repo.purge(change, opts),
         {:ok, response} <- Response.return(@schema_name, :delete, struct) do
      {:ok, %{@schema_name => struct, :response => response}}
    else
      error ->
        error
    end
  end

  def update(attrs, sess, opts \\ []) do
    modify(attrs, :update, sess, opts)
  end
end
