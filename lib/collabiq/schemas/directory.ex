defmodule Collabiq.Directory do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Collabiq.{Proxy, Query, Repo, Security, Site}

  @schema_name :directory
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "directories" do
    field(:description, :string)
    field(:name, :string)
    field(:pw, :string)
    field(:server, :string)
    field(:status, :string, default: "active")
    field(:tenant_id, :binary_id)
    field(:un, :string)

    timestamps(inserted_at: :created_at, type: :utc_datetime)
    field(:deleted_at, :utc_datetime)

    belongs_to(:proxy, Proxy)
    belongs_to(:site, Site)
    # has_many(:locations, Location)
    # has_many(:sites, Site)
    # has_many(:users_workspaces, UserWorkspace, on_replace: :delete)
    # has_many(:users, through: [:users_workspaces, :user])
  end

  ### Changesets ###

  @attrs_status ["active", "deleted", "disabled"]
  @optional [:deleted_at, :description, :pw, :status, :un]
  @required [:name, :site_id, :server]

  def cs(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @optional ++ @required)
    |> validate_required(@required)
    |> validate_inclusion(:status, @attrs_status)
    |> foreign_key_constraint(:site_id)
    |> foreign_key_constraint(:tenant_id)
  end

  ### API Functions ###
  def create(attrs, sess) do
    site_id = Map.get(attrs, "site_id") || Map.get(attrs, :site_id)
    attrs = Map.drop(attrs, ["deleted_at", :deleted_at, "status", :status])

    with :ok <- Security.validate_perms(%{admin: [:create_directory]}, sess),
         change <- cs(%__MODULE__{tenant_id: sess.t_id}, attrs),
         :ok <- Repo.validate_change(change),
         {:ok, _site} <- Collabiq.get_site(site_id, sess),
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
             %{admin: [:create_directory, :manage_directory, :purge_directory]},
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
             %{admin: [:create_directory, :manage_directory, :purge_directory]},
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

    with :ok <- Security.validate_perms(%{admin: [:manage_directory]}, sess),
         {:ok, struct} <- get(id, sess),
         change <- cs(struct, attrs),
         change <- change_site(change, sess),
         :ok <- Repo.validate_change(change),
         {:ok, struct} <- Repo.put(change) do
      {:ok, struct}
    else
      error ->
        error
    end
  end

  def purge(id, sess) do
    with :ok <- Security.validate_perms(%{admin: [:purge_directory]}, sess),
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
    Map.drop(attrs, ["deleted_at", :deleted_at, "status", :status])
    |> modify(sess)
  end

  defp change_site(%{params: %{"site_id" => site_id}} = change, sess) do
    with {:ok, _site} <- Collabiq.get_site(site_id, sess) do
      change
    else
      error ->
        error
    end
  end

  defp change_site(change, _sess), do: change
end
