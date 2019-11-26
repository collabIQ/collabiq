defmodule Collabiq.Tenant do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Collabiq.{Repo, Response, Security}

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

  @spec cs(%__MODULE__{}, map()) :: {:ok, Ecto.Changeset.t()} | {:error, [any()]}
  def cs(%__MODULE__{} = tenant, attrs) do
    tenant
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> validate_inclusion(:status, @attrs_status)
    |> unique_constraint(:name)
    |> Repo.validate_change()
  end

  ### API Functions ###
  def create_tenant(attrs, opts \\ []) do
    with {:ok, change} <- cs(%__MODULE__{}, attrs),
         {:ok, tenant} <- Repo.put(change, opts) do
      {:ok, tenant}
    else
      error ->
        error
    end
  end

  def delete_tenant(sess, opts \\ []) do
    %{status: "deleted", deleted_at: Timex.now()}
    |> modify_tenant(:delete, sess, opts)
  end

  def enable_tenant(sess, opts \\ []) do
    %{status: "active", deleted_at: nil}
    |> modify_tenant(:enable, sess, opts)
  end

  def get_tenant(sess, opts \\ []) do
    with :ok <- Security.validate_systems_perms([:manage_tenant, :purge_tenant], sess),
         {:ok, tenant} <-
           from(t in __MODULE__,
             where: t.id == ^sess.t_id
           )
           |> Repo.single(opts)
           |> Repo.validate_read(:tenant) do
      {:ok, tenant}
    else
      error ->
        error
    end
  end

  def modify_tenant(attrs, body, sess, opts) do
    with :ok <- Security.validate_systems_perms(:manage_tenant, sess),
         {:ok, tenant} <- get_tenant(sess, [id: :binary_id]),
         {:ok, change} <- cs(tenant, attrs),
         {:ok, tenant} <- Repo.put(change, opts),
         {:ok, response} <- Response.return(:tenant, body, tenant) do
      {:ok, %{tenant: tenant, response: response}}
    else
      error ->
        error
    end
  end

  def purge_tenant(sess, opts \\ []) do
    with :ok <- Security.validate_systems_perms(:purge_tenant, sess),
         {:ok, tenant} <- get_tenant(sess, opts),
         {:ok, change} <- cs(tenant, %{}),
         {:ok, tenant} <- Repo.purge(change, opts),
         {:ok, response} <- Response.return(:tenant, :delete, tenant) do
       {:ok, %{tenant: tenant, response: response}}
    else
      error ->
        error
    end
  end

  def update_tenant(attrs, sess, opts \\ []) do
    modify_tenant(attrs, :update, sess, opts)
  end
end
