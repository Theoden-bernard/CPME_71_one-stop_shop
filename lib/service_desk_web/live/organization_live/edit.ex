defmodule ServiceDeskWeb.Live.OrganizationLive.Edit do
    use ServiceDeskWeb, :live_view
    alias ServiceDesk.{Organizations, Repo}

    def mount(_, _, socket) do
        {organization_changeset, action} =
            case socket.assigns.current_user
            |> Repo.preload(:organization)
            |> Map.get(:organization) do
                nil -> {Organizations.Organization.changeset(%Organizations.Organization{}), :new}
                organization -> {Organizations.Organization.changeset(organization), :edit}
            end

        {:ok, 
            socket
            |> assign(:form, to_form(organization_changeset))
            |> assign(:changeset, organization_changeset)
            |> assign(:action, action)}
    end

    def handle_event("create_info", _params, socket)when socket.assigns.action == :new do
        Organizations.create_organization(socket)
        {:noreply, socket}
    end

    def handle_event("update_info", params, socket)when socket.assigns.action == :edit do
        Organizations.update_organization(params, socket)
        {:noreply, socket}
    end
end