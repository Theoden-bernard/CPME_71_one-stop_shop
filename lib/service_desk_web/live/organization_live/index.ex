defmodule ServiceDeskWeb.Live.OrganizationLive.Index do
    use ServiceDeskWeb, :live_view
    alias ServiceDesk.Organizations

    def mount(_, _, socket) do
        organizations_list = Organizations.list_organizations()
        {:ok, assign(socket, :organizations_list, organizations_list)}
    end
end