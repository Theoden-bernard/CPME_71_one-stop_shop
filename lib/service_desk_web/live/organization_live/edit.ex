defmodule ServiceDeskWeb.Live.OrganizationLive.Edit do
    use ServiceDeskWeb, :live_view
    alias ServiceDesk.{Organizations, Repo}

    def mount(_, _, socket) do
        {organization, action} =
            case socket.assigns.current_user
            |> Repo.preload(:organization)
            |> Map.get(:organization) do
                nil -> {%Organizations.Organization{}, :new}
                organization -> {organization, :edit}
            end

        form = 
            organization
            |> Ecto.Changeset.change()
            |> to_form()

        {:ok, 
            socket
            |> assign(:form, form)
            |> assign(:organization, organization)
            |> assign(:action, action)}
    end

    def handle_event("save", %{"organization" => params}, socket) when socket.assigns.action == :new do
        params = Map.put(params, "user_id", socket.assigns.current_user.id) 
        case Organizations.create_organization(params) do
            {:ok, _organization} -> 
                {:noreply, put_flash(socket, :info, "Votre organisation a bien été créée")}

            {:error, changeset} ->
                {:noreply, assign(socket, :form, to_form(changeset))}
        end
    end

    def handle_event("save", %{"organization" => params}, socket) when socket.assigns.action == :edit do
        case Organizations.update_organization(socket.assigns.organization, params) do
            {:ok, _organization} -> 
                {:noreply, put_flash(socket, :info, "Votre organisation a bien été modifiée")}

            {:error, changeset} ->
                {:noreply, assign(socket, :form, to_form(changeset))}
        end
    end
end