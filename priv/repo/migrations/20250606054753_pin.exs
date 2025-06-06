defmodule ServiceDesk.Repo.Migrations.Pin do
  use Ecto.Migration

  def change do
    create table(:pins) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :puid, :bigint, null: false
      add :pin, :integer, null: false
     
      timestamps()
    end

#    create unique_index(:pins, [:puid])
  end
end
