defmodule ServiceDesk.Tags.Tag do
    use Ecto.Schema
    import Ecto.Changeset

    schema "tags" do
        field :name, :string
        many_to_many :organizations, ServiceDesk.Organizations.Organization, join_through: :organizations_tags
    end

    def changeset(tag, attrs \\ %{}) do
        tag
        |> cast(attrs, [:name])
        |> validate_required([:name])
    end
end