defmodule ServiceDesk.Repo.Migrations.ContactCreate do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :message, :binary
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end
  end
end
