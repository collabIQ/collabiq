defmodule Collabiq.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create table(:sites, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :citext, null: false
      add :description, :string
      add :status, :string, null: false

      add :tenant_id, references(:tenants, on_delete: :delete_all, type: :binary_id), null: false
      timestamps([inserted_at: :created_at, type: :utc_datetime])
      add :deleted_at, :utc_datetime
    end

    create index(:sites, [:name])
    create index(:sites, [:tenant_id])
  end
end
