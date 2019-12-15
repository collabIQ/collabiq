defmodule Collabiq.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :citext
      add :address, :string
      add :city, :string
      add :cn, :string
      add :company, :string
      add :country, :string
      add :description, :string
      add :display_name, :string
      add :division, :string
      add :dn, :string
      add :email, :string
      add :fax, :string
      add :first_name, :citext
      add :home_page, :string
      add :home_phone, :string
      add :last_name, :citext
      add :logon_count, :integer
      add :mobile_phone, :string
      add :office_phone, :string
      add :organization, :string
      add :po, :string
      add :pw_last_set, :utc_datetime
      add :sam, :string
      add :state, :string
      add :title, :string
      add :type, :string
      add :upn, :string
      add :zip, :string

      add :created_at, :utc_datetime
      add :last_logon_at, :utc_datetime
      add :pw_set_at, :utc_datetime
      add :updated_at, :utc_datetime

      add :directory_id, references(:directories, on_delete: :delete_all, type: :binary_id)
      add :site_id, references(:directories, on_delete: :delete_all, type: :binary_id), null: false
      add :tenant_id, references(:directories, on_delete: :delete_all, type: :binary_id), null: false
    end

    create index(:users, [:name])
    create index(:users, [:email])
    create index(:users, [:site_id])
    create index(:users, [:tenant_id])
  end
end
