defmodule ServiceDesk.Repo.Migrations.UserAddInfo do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :firstname, :string
      add :lastname, :string 
      add :gsm, :string
      add :landline , :string
    end
  end
end
