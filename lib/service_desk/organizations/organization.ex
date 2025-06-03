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
        field :siren, :string
        field :siret; :string
        belongs_to :user, ServiceDesk.Accounts.User
        many_to_many :tags, ServiceDesk.Tags.Tag, join_through: "organizations_tags"
        many_to_many :zones, ServiceDesk.Zones.Zone, join_through: "organizations_zones"
    end

    def changeset(organization, attrs \\ %{}) do
        organization
        |> cast(attrs, [:name, :email, :landline, :address_1, :address_2, :zip_code, :city, :siren, :siret])
        |> validate_required([:name, :email, :landline, :address_1, :zip_code, :city])
    end
end