defmodule Collabiq.Site do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Collabiq.{Directory, Query, Repo, Security, UUID}

  @schema_name :site
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sites" do
    field(:description, :string)
    field(:name, :string)
    field(:status, :string, default: "active")
    field(:tenant_id, :binary_id)
    timestamps(inserted_at: :created_at, type: :utc_datetime)
    field(:deleted_at, :utc_datetime)

    has_many(:directories, Directory)
  end

  ### Changesets ###

  @attrs_status ["active", "deleted", "disabled"]
  @optional [:deleted_at, :description, :status]
  @required [:name]

  # @spec cs(%__MODULE__{}, map()) :: {:ok, Ecto.Changeset.t()} | {:error, [any(), ...]}
  def cs(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @optional ++ @required)
    |> validate_required(@required)
    |> validate_inclusion(:status, @attrs_status)
    |> foreign_key_constraint(:tenant_id)
  end

  ### API Functions ###
  def create(attrs, sess) do
    attrs = Map.drop(attrs, ["deleted_at", :deleted_at, "status", :status])

    with :ok <- Security.validate_perms(%{admin: [:create_site]}, sess),
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
    with :ok <- Security.validate_perms(%{admin: [:create_site, :manage_site, :purge_site]}, sess),
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
    with :ok <- Security.validate_perms(%{admin: [:create_site, :manage_site, :purge_site]}, sess),
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

    with :ok <- Security.validate_perms(%{admin: [:manage_site]}, sess),
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
    with :ok <- Security.validate_perms(%{admin: [:purge_site]}, sess),
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
end
