defmodule ServiceDesk.Organizations do
    import Ecto.Query, warn: false
    alias ServiceDesk.{Accounts, KeywordSearch, Repo, Tags}
    alias ServiceDesk.Organizations.Organization
    alias Ecto.Changeset

    def get_organization!(id),
        do: Repo.get!(Organization, id)

    def list_organizations do
        Repo.all(Organization)
    end

    def create_organization(%{"user_id" => user_id} = attrs) when is_integer(user_id) and user_id > 0 do
        user_id
        |> Accounts.get_user!()
        |> Ecto.build_assoc(:organization)
        |> Organization.changeset(attrs)
        |> Repo.insert()
    end

    def create_organization(%Accounts.User{} = user, attrs) do
        user 
	|> Ecto.build_assoc(:organization)
        |> Organization.changeset(attrs)
        |> Repo.insert()
    end

    def create_organization(_attrs) do
        {:error,
            %Organization{}
            |> Changeset.change()
            |> Changeset.add_error(:user, "Organization can't be blanck")}
    end
    
    def update_organization(organization, attrs) do
        organization
        |> Organization.changeset(attrs)
        |> Repo.update()
    end

    def delete_organization(organization) do
      Repo.delete(organization)
    end

    def change_organization(%Organization{} = organization, attrs),
      do: Organization.changeset(organization, attrs)

    def list_organizations_by_message(message) do
      list_organizations()
      |> Repo.preload([:zones, :tags])
      |> Enum.filter(&(KeywordSearch.keywords?(message.message, Tags.to_keywords(&1.tags))))
    end

end
