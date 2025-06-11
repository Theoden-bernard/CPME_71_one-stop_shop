defmodule ServiceDeskWeb.Live.OrganizationLive.ShowComponent do
    use ServiceDesk, :live_component

    def update(organization, socket) do
        socket
        |> assign(:organization, organization)
        
        {:ok, 
        socket
        |> assign(:organization, organization)}
    end
end