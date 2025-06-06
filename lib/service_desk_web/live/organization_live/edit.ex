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
            |> allow_upload(:logo, accept: ~w(.jpg .jpeg .png))}
    end

    def handle_event("save", %{"organization" => params}, socket) do
	params = Map.put(params, "user_id", socket.assigns.current_user.id) 
        consume_uploaded_entries(socket, :logo, fn
	  %{path: path}, _entry ->
	    extension = get_extension(path)
	  filename = socket.assigns.current_user.id |> Integer.to_string() |> Kernel.<>(".#{extension}")
          dest = Path.join(Application.app_dir(:service_desk,  "priv/static/images/organizations/logo"), filename) 
          File.cp!(path, dest)
          {:ok, ~p"/images/organizations/logo/#{filename}"}
        end)
	
	save_data(socket.assigns.action, params, socket)
    end

    def handle_event("validate",  %{"organization" => params}, socket),
      do: {:noreply, assign(socket, :to_form, to_form(Organizations.change_organization(socket.assigns.organization, params)))}
    
    defp save_data(:new, params, socket) do
      case Organizations.create_organization(params) do
        {:ok, _organization} -> 
          {:noreply, put_flash(socket, :info, "Votre organisation a bien été créée")}
	  
          {:error, changeset} ->
          {:noreply, assign(socket, :form, to_form(changeset))}
      end
    end
    
    defp save_data(:edit, params, socket) do
      case Organizations.update_organization(socket.assigns.organization, params) do
        {:ok, _organization} -> 
          {:noreply, put_flash(socket, :info, "Votre organisation a bien été modifiée")}
	  
          {:error, changeset} ->
          {:noreply, assign(socket, :form, to_form(changeset))}
      end
    end

    defp get_extension(filename) do
      case Path.extname(filename) do
	"" ->
	  filename
	  |> FileInfo.get_info()
	  |> Map.get(filename)
	  |> Map.get(:subtype)
	  
	ext -> ext
      end
    end
end
