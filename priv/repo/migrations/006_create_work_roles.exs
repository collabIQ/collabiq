defmodule Collabiq.Migrations.CreateWorkRoles do
  use Ecto.Migration

  def change do
    create table(:work_roles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :citext, null: false
      add :description, :string
      add :perms, :map, null: false

      add :site_id, references(:tenants, on_delete: :delete_all, type: :binary_id), null: false
      add :tenant_id, references(:tenants, on_delete: :delete_all, type: :binary_id), null: false

      timestamps([inserted_at: :created_at, type: :utc_datetime])
    end

    create unique_index(:sites_roles, [:site_id, :name])
    create index(:sites_roles, [:name])
    create index(:sites_roles, [:site_id])
    create index(:sites_roles, [:tenant_id])
  end
end
