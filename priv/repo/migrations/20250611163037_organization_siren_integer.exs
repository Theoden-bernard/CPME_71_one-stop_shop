defmodule ServiceDesk.Repo.Migrations.OrganizationSirenInteger do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      remove_if_exists :siren
      add :siren, :integer
    end

    create unique_index(:organizations, :siren)
    create unique_index(:tags, :name)
  end
end
