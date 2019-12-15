defmodule Collabiq.Migrations.CreateAdminRoles do
  use Ecto.Migration

  def change do
    create table(:admin_roles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :citext, null: false
      add :description, :string
      add :perms, :map, null: false

      add :tenant_id, references(:tenants, on_delete: :delete_all, type: :binary_id), null: false

      timestamps([inserted_at: :created_at, type: :utc_datetime])
    end

    create unique_index(:admin_roles, [:tenant_id, :name])
    create index(:admin_roles, [:name])
    create index(:admin_roles, [:tenant_id])
  end
end
