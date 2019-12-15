defmodule Collabiq.Migrations.CreateSitesWorkRoles do
  use Ecto.Migration

  def change do
    create table(:sites_work_roles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :perms, :map, null: false

      add :site_id, references(:sites, on_delete: :delete_all, type: :binary_id), null: false
      add :tenant_id, references(:tenants, on_delete: :delete_all, type: :binary_id), null: false
      add :work_role_id, references(:work_roles, on_delete: :delete_all, type: :binary_id), null: false
    end

    create unique_index(:sites_work_roles, [:site_id, :work_role_id])
    create index(:sites_work_roles, [:site_id])
    create index(:sites_work_roles, [:tenant_id])
    create index(:sites_work_roles, [:work_role_id])
  end
end
