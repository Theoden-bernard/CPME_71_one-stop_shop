defmodule ServiceDesk.Tags do 
    import Ecto.Query, warn: false
    alias ServiceDesk.{Accounts, Repo}
    alias ServiceDesk.Tags.Tag
    alias Ecto.Changeset

    def get_tag!(id), 
        do: Repo.get!(Tag, id)

    def list_tags do
        Repo.all(Tag)
    end

    def create_tag(%{"user_id" => user_id} = attrs) when is_integer(user_id) and user_id > 0 do
        user_id
        |> Accounts.get_user!()
        |> Ecto.build_assoc(:tags, attrs)
        |> Tag.changeset()
        |> Repo.insert()
    end

    def create_tag(_attrs) do 
        {:error,
            %Tag{}
            |> Changeset.change()
            |> Changeset.add_error(:user, "User can't be blanck")}
    end
    
    def update_tag(tag, attrs) do
        tag
        |> Tag.changeset(attrs)
        |> Repo.update()
    end

    def delete_tag(tag) do
        Repo.delete(tag)
    end
end