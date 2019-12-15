defmodule Collabiq.Tenant do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Collabiq.{Repo, Security}

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "tenants" do
    field(:name, :string)
    field(:status, :string, default: "active")

    timestamps(inserted_at: :created_at, type: :utc_datetime)
    field(:deleted_at, :utc_datetime)
  end

  ### Changesets ###

  @attrs_status ["active", "deleted", "suspended"]
  @required [:name]

  def cs(%__MODULE__{} = tenant, attrs) do
    tenant
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> validate_inclusion(:status, @attrs_status)
    |> unique_constraint(:name)
  end

  ### API Functions ###
  def create(attrs) do
    with change <- cs(%__MODULE__{}, attrs),
         :ok <- Repo.validate_change(change),
         {:ok, tenant} <- Repo.put(change) do
      {:ok, tenant}
    else
      error ->
        error
    end
  end

  def delete_tenant(sess) do
    %{status: "deleted", deleted_at: Timex.now()}
    |> modify_tenant(sess)
  end

  def enable_tenant(sess) do
    %{status: "active", deleted_at: nil}
    |> modify_tenant(sess)
  end

  def get(sess) do
    with :ok <- Security.validate_perms(%{admin: [:manage_tenant, :purge_tenant]}, sess),
         {:ok, tenant} <-
           __MODULE__
           |> where([q], q.id == ^sess.t_id)
           |> Repo.one()
           |> Repo.validate_read(:tenant) do
      {:ok, tenant}
    else
      error ->
        error
    end
  end

  def modify_tenant(attrs, sess) do
    with :ok <- Security.validate_perms(%{admin: [:manage_tenant]}, sess),
         {:ok, struct} <- get(sess),
         change <- cs(struct, attrs),
         :ok <- Repo.validate_change(change),
         {:ok, struct} <- Repo.put(change) do
      {:ok, struct}
    else
      error ->
        error
    end
  end

  def purge_tenant(sess) do
    with :ok <- Security.validate_perms(%{admin: [:purge_tenant]}, sess),
         {:ok, struct} <- get(sess),
         change <- cs(struct, %{}),
         :ok <- Repo.validate_change(change),
         {:ok, struct} <- Repo.purge(change) do
       {:ok, struct}
    else
      error ->
        error
    end
  end

  def update_tenant(attrs, sess) do
    modify_tenant(attrs, sess)
  end
end
