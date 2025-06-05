defmodule ServiceDeskWeb.Live.OrganizationLive.Edit do
    use ServiceDeskWeb, :live_view
    alias ServiceDesk.{Organizations, Repo}
    # @impl Phoenix.LiveView

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
            |> assign(:action, action)
            |> assign(:logo, [])
            |> allow_upload(:logo, accept: ~w(.jpg .jpeg .png), max_entries: 1)}
    end

    def handle_event("save", %{"organization" => params}, socket) when socket.assigns.action == :new do
        params = Map.put(params, "user_id", socket.assigns.current_user.id) 
        path = "priv/static/uploads"

        uploaded_files =
            consume_uploaded_entries(socket, :logo, fn %{path: path}, _entry ->
            dest = Path.join(Application.app_dir(:my_app, "priv/static/uploads"), Path.basename(path))
            File.cp!(path, dest)
            {:ok, ~p"/uploads/#{Path.basename(dest)}"}
        end)

        case Organizations.create_organization(params) do
            {:ok, _organization} -> 
                {:noreply, put_flash(socket, :info, "Votre organisation a bien été créée")}

            {:error, changeset} ->
                {:noreply, assign(socket, :form, to_form(changeset))}
        end
    end

    def handle_event("save", %{"organization" => params}, socket) when socket.assigns.action == :edit do
        path = "priv/static/uploads"

        IO.inspect("toto")

        uploaded_files =
            consume_uploaded_entries(socket, :logo, fn %{path: path}, _entry ->
            dest = Path.join(Application.app_dir(:my_app, "priv/static/uploads"), Path.basename(path))
            File.cp!(path, dest) |> IO.inspect(label: "FILE")
            {:ok, ~p"/uploads/#{Path.basename(dest)}"}
        end)
        
        case Organizations.update_organization(socket.assigns.organization, params) do
            {:ok, _organization} -> 
                {:noreply, put_flash(socket, :info, "Votre organisation a bien été modifiée")}

            {:error, changeset} ->
                {:noreply, assign(socket, :form, to_form(changeset))}
        end
    end
end