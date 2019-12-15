defmodule Collabiq.Migrations.CreateAgents do
  use Ecto.Migration

  def change do
    create table(:agents, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :citext
      add :email, :citext
      add :pw, :string
      add :status, :string

      add :admin_role_id, references(:admin_roles, on_delete: :delete_all, type: :binary_id)
      add :tenant_id, references(:tenants, on_delete: :delete_all, type: :binary_id), null: false
      add :work_role_id, references(:work_roles, on_delete: :delete_all, type: :binary_id)

      timestamps([inserted_at: :created_at, type: :utc_datetime])
      add :deleted_at, :utc_datetime
    end

    create unique_index(:agents, [:email])
    create index(:agents, [:name])
    create index(:agents, [:admin_role_id])
    create index(:agents, [:tenant_id])
    create index(:agents, [:work_role_id])
  end
end
