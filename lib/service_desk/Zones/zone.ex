defmodule ServiceDesk.Zones.Zone do
    use Ecto.Schema
    import Ecto.Changeset

    schema "zones" do
        field :name, :string
        field :number, :integer
        many_to_many :organizations, ServiceDesk.Organizations.Organization, join_through: :organizations_zones
    end

    def changeset(zone, attrs \\ %{}) do
        zone
        |> cast(attrs, [:name, :number])
        |> validate_required([:name, :number])
    end
end