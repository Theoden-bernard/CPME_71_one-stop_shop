defmodule ServiceDesk.Organizations.Organization do
    use Ecto.Schema
    import Ecto.Changeset

    schema "organizations" do
        field :name, :string
        field :email, :string
        field :landline, :string
        field :address_1, :string
        field :address_2, :string
        field :zip_code, :string
        field :city, :string
        field :siren, :integer
        field :siret, :string
        field :baseline, :string
        field :activity, :string
        field :website, :string
        field :linkedin, :string
        field :youtube, :string
        field :x, :string
        field :pappers, :string
        field :tva, :string
        field :naf, :string
        field :domaine, :string
    #	field :presentation, :string
        field :certifications, :string
        field :country, :string
        field :address_1_2, :string
        field :address_2_2, :string
        field :zip_code_2, :string
        field :city_2, :string
        field :country_2, :string
        field :address_1_3, :string
        field :address_2_3, :string
        field :zip_code_3, :string
        field :city_3, :string
        field :country_3, :string
        belongs_to :user, ServiceDesk.Accounts.User, on_replace: :delete
        many_to_many :tags, ServiceDesk.Tags.Tag, join_through: "organizations_tags"
        many_to_many :zones, ServiceDesk.Zones.Zone, join_through: "organizations_zones"
        field :uploaded_files, :binary
    end

    def changeset(organization, attrs \\ %{}) do
        organization
        |> cast(attrs, [:name, :email, :landline, :address_1, :address_2, :zip_code, :city, :siren, :siret, :baseline, :activity, :website, :linkedin, :youtube, :x, :pappers, :tva, :naf, :domaine, :certifications, :certifications, :certifications, :certifications, :country, :address_1_2, :address_2_2, :zip_code_2, :city_2, :country_2, :address_1_3, :address_2_3, :zip_code_3, :city_3, :country_3])
        |> validate_required([:name, :email, :landline, :address_1, :zip_code, :city])
    end
end
