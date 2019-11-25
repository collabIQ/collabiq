defmodule Collabiq.Migrations.CreateDirectories do
  use Ecto.Migration

  def change do
    create table(:directories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :citext, null: false
      add :description, :string
      add :pw, :string
      add :server, :string, null: false
      add :status, :string, null: false
      add :un, :string

      add :proxy_id, references(:proxies, on_delete: :nilify_all, type: :binary_id), null: false
      add :site_id, references(:sites, on_delete: :delete_all, type: :binary_id), null: false
      add :tenant_id, references(:tenants, on_delete: :delete_all, type: :binary_id), null: false
      timestamps([inserted_at: :created_at, type: :utc_datetime])
      add :deleted_at, :utc_datetime
    end

    create index(:directories, [:site_id])
    create index(:directories, [:tenant_id])
  end
end
