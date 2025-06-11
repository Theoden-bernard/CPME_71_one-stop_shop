defmodule ServiceDesk.Repo.Migrations.ChangeSirenToString do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      modify :siren, :string
      modify :siret, :string
    end
  end
end
