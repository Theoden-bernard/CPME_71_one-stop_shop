defmodule ServiceDeskWeb.Live.OrganizationLive.ShowComponent do
    use ServiceDeskWeb, :live_component

    def update(%{organization: organization}, socket) do
        {:ok,
         socket
         |> assign(:organization, organization)}
    end
end
