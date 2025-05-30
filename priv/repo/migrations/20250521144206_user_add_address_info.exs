defmodule ServiceDesk.Repo.Migrations.UserAddAddressInfo do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :address_1, :string
      add :address_2, :string
      add :zip_code, :string
      add :city, :string
    end
  end
end
