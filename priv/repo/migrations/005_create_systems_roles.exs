defmodule Collabiq.Migrations.CreateSystemsRoles do
  use Ecto.Migration

  def change do
    create table(:systems_roles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :citext, null: false
      add :description, :string
      add :create_directory, :boolean
      add :manage_directory, :boolean
      add :purge_directory, :boolean
      add :create_proxy, :boolean
      add :manage_proxy, :boolean
      add :purge_proxy, :boolean
      add :create_site, :boolean
      add :manage_site, :boolean
      add :purge_site, :boolean
      add :create_site_role, :boolean
      add :manage_site_role, :boolean
      add :purge_site_role, :boolean
      add :create_system_role, :boolean
      add :manage_system_role, :boolean
      add :purge_system_role, :boolean
      add :manage_tenant, :boolean
      add :purge_tenant, :boolean

      add :tenant_id, references(:tenants, on_delete: :delete_all, type: :binary_id), null: false

      timestamps([inserted_at: :created_at, type: :utc_datetime])
    end

    create unique_index(:systems_roles, [:tenant_id, :name])
    create index(:systems_roles, [:name])
    create index(:systems_roles, [:tenant_id])
  end
end
