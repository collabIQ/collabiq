defmodule Collabiq.Directory do
  @moduledoc "Module for defining the schema and changesets for workspace objects."
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  #alias Collabiq.Org.{Location, Site, UserWorkspace}
  alias Collabiq.{Proxy, Query, Repo, Response, Security, Site, UUID}

  @schema_name :directory
  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "directories" do
    field(:description, :string)
    field(:name, :string)
    field(:pw, :string)
    field(:server, :string)
    field(:status, :string, default: "active")
    #field(:user_count, :integer, default: 0, virtual: true)
    field(:tenant_id, :binary_id)
    field(:un, :string)

    timestamps(inserted_at: :created_at, type: :utc_datetime)
    field(:deleted_at, :utc_datetime)

    belongs_to(:proxy, Proxy)
    belongs_to(:site, Site)
    #has_many(:locations, Location)
    #has_many(:sites, Site)
    #has_many(:users_workspaces, UserWorkspace, on_replace: :delete)
    #has_many(:users, through: [:users_workspaces, :user])
  end

  ### Changesets ###

  @attrs_status ["active", "deleted", "disabled"]
  @optional [:deleted_at, :description, :pw, :status, :un]
  @required [:name, :server]

  @spec cs(%__MODULE__{}, map()) :: {:ok, Ecto.Changeset.t()} | {:error, [any(), ...]}
  def cs(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @optional ++ @required)
    |> validate_required(@required)
    |> validate_inclusion(:status, @attrs_status)
    |> foreign_key_constraint(:site_id)
    |> foreign_key_constraint(:tenant_id)
    |> Repo.validate_change()
  end

  ### API Functions ###
  def create(attrs, sess, opts \\ []) do
    with :ok <- Security.validate_systems_perms(:create_directory, sess),
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
         :ok <- Security.validate_systems_perms([:create_directory, :manage_directory, :purge_directory], sess),
         {:ok, struct} <-
           get_query(id, sess, opts)
           |> Query.site_scope(sess, @schema_name)
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

    with :ok <- Security.validate_systems_perms([:create_directory, :manage_directory, :purge_directory], sess),
         {:ok, structs} <-
           query
           |> Query.site_scope(sess, @schema_name)
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
    with :ok <- Security.validate_systems_perms(:manage_directory, sess),
         {:ok, struct} <- get(attrs, sess, [id: :binary_id]),
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
         :ok <- Security.validate_systems_perms(:purge_directory, sess),
         {:ok, struct} <- get(id, sess, [id: :binary_id]),
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
