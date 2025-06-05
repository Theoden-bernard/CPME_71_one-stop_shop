defmodule ServiceDesk.Repo.Migrations.OrganizationCreat do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string
      add :email, :string
      add :landline, :string
      add :address_1, :string
      add :address_2, :string
      add :zip_code, :string
      add :city, :string
      add :siren, :string
      add :siret, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :uploaded_files, :binary
    end

    create table(:tags) do
      add :name, :string
    end

    create table(:zones) do
      add :name, :string
      add :number, :integer
    end

    create table(:organizations_tags) do
      add :tag_id, references(:tags)
      add :organization_id, references(:organizations)
    end

    create unique_index(:organizations_tags, [:tag_id, :organization_id])

    create table(:organizations_zones) do
      add :zone_id, references(:zones)
      add :organization_id, references(:organizations)
    end

    create unique_index(:organizations_zones, [:zone_id, :organization_id])
  end
end
