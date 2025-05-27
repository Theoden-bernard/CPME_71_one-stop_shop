defmodule ServiceDesk.Organizations do
    import Ecto.Query, warn: false
    alias ServiceDesk.{Accounts, Repo}
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
        |> Ecto.build_assoc(:organization, attrs)
        |> Organization.changeset()
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
end