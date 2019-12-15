defmodule Collabiq.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :tenant_id, references(:tenants, on_delete: :delete_all, type: :binary_id), null: false
      add :ip_address, :string
      add :agent_id, references(:agents, on_delete: :delete_all, type: :binary_id), null: false

      timestamps([inserted_at: :created_at, type: :utc_datetime])
    end

    create index(:sessions, [:tenant_id])
    create index(:sessions, [:agent_id])
  end
end
