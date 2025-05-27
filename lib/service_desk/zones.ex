defmodule ServiceDesk.Zones do
    import Ecto.Query, warn: false
    alias ServiceDesk.{Accounts, Repo}
    alias ServiceDesk.Zones.Zone
    alias Ecto.Changeset

    def get_zone!(id),
        do: Repo.get!(Zone, id)

    def list_zones do
        Repo.all(Zone)
    end

    def create_zone(%{"user_id" => user_id} = attrs) when is_integer(user_id) and user_id > 0 do
        user_id
        |> Accounts.get_user!()
        |> Ecto.build_assoc(:zone, attrs)
        |> Zone.changeset()
        |> Repo.insert()
    end

    def create_zone(_attrs) do
        {:error,
            %Zone{}
            |> Changeset.change()
            |> Changeset.add_error(:user, "user can't be blanck")}
    end
    
    def update_zone(zone, attrs) do
        zone
        |> Zone.changeset(attrs)
        |> Repo.update()
    end

    def delete_zone(zone) do
        Repo.delete(zone)
    end
end