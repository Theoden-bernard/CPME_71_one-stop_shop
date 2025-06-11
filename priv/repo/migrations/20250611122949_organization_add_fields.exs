defmodule ServiceDesk.Repo.Migrations.OrganizationAddFields do
  use Ecto.Migration

  def change do
    alter table(:organizations) do
      add :baseline, :string
      add :activity, :string
      add :website, :string
      add :linkedin, :string
      add :youtube, :string
      add :x, :string
      add :pappers, :string
      add :tva, :string
      add :naf, :string
      add :domaine, :string
      add :certifications, :string
      add :country, :string
      add :address_1_2, :string
      add :address_2_2, :string
      add :zip_code_2, :string
      add :city_2, :string
      add :country_2, :string
      add :address_1_3, :string
      add :address_2_3, :string
      add :zip_code_3, :string
      add :city_3, :string
      add :country_3, :string
    end
  end
end
