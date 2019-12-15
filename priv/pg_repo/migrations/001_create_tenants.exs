defmodule Collabiq.Migrations.CreateTenants do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext",  "DROP EXTENSION IF EXISTS citext"
    create table(:tenants, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :status, :string, null: false

      timestamps([inserted_at: :created_at, type: :utc_datetime])
      add :deleted_at, :utc_datetime
    end

    create unique_index(:tenants, [:name])
  end
end
