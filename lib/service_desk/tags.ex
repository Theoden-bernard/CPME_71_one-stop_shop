defmodule ServiceDesk.Tags do 
    import Ecto.Query, warn: false
    alias ServiceDesk.Repo
    alias ServiceDesk.Tags.Tag
    alias ServiceDesk.Organizations.Organization
    alias Ecto.Changeset

    def get_tag!(id), 
        do: Repo.get!(Tag, id)

    def get_tag_by_name(name), 
        do: Repo.get_by(Tag, name: name)

    def get_tag_by_name!(name), 
        do: Repo.get_by!(Tag, name: name)

    def list_tags do
        Repo.all(Tag)
    end

    def create_tag(attrs) do
      %Tag{}
      |> Tag.changeset(attrs)
      |> Repo.insert()
    end
    
    def update_tag(tag, attrs) do
        tag
        |> Tag.changeset(attrs)
        |> Repo.update()
    end

    def delete_tag(tag) do
        Repo.delete(tag)
    end

    def to_keywords(tags),
      do: Enum.map(tags, &(&1.name))


    def add_tag_to_organization(%Tag{} = tag, %Organization{} = organization) do
        organization = Repo.preload(organization, :tags)
        tags = Map.get(organization, :tags)
        organization_changeset = Ecto.Changeset.change(organization)
        Changeset.put_assoc(organization_changeset, :tags, [tag | tags])
        |> Repo.update()        
    end
end
