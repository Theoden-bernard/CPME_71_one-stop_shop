defmodule ServiceDesk.Tags do 
    import Ecto.Query, warn: false
    alias ServiceDesk.Repo
    alias ServiceDesk.Tags.Tag

    def get_tag!(id), 
        do: Repo.get!(Tag, id)

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
end
