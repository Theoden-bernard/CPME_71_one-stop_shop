defmodule ServiceDeskWeb.Live.OrganizationLive.ShowComponent do
    use ServiceDeskWeb, :live_component

    def update(%{organization: organization}, socket) do
        socket
        |> assign(:organization, organization)
        
        {:ok, 
        socket
        |> assign(:organization, organization)}
    end
end