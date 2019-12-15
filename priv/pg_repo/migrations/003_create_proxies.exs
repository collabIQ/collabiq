defmodule Collabiq.Migrations.CreateProxies do
  use Ecto.Migration

  def change do
    create table(:proxies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :citext, null: false
      add :description, :string
      add :status, :string, null: false

      add :tenant_id, references(:tenants, on_delete: :delete_all, type: :binary_id), null: false
      timestamps([inserted_at: :created_at, type: :utc_datetime])
      add :deleted_at, :utc_datetime
    end

    create index(:proxies, [:tenant_id])
  end
end
