defmodule ServiceDeskWeb.HelpLive do
  use ServiceDeskWeb, :live_view
  alias ServiceDesk.{Messages, Organizations, Tags}

  def mount(_, _, socket) do
    message =  Messages.new_message()
    form =
      message
      |> Messages.change_message()
      |> to_form()

    {:ok,
     socket
     |> assign(:live_action, nil)
     |> assign(:form, form)
     |> assign(:organizations, Organizations.list_organizations())
     |> assign(:message, message)
     |> assign(:show_all_tags, false)
     |> assign(:has_search_query, false)}
  end

  def handle_params(%{"id" => id}, _, socket) do
    organization = Organizations.get_organization!(id)
    {:noreply,
     socket
     |> assign(:live_action, :show)
     |> assign(:organization, organization)}
  end

  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  def handle_event("validate", %{"message" => params}, socket) do
    case Messages.change_message(socket.assigns.message, params) do
      changeset when changeset.valid? ->
        message = Ecto.Changeset.apply_changes(changeset)
        message_value = Map.get(params, "message", "")
        has_search_query = String.trim(message_value) != ""

        organizations_list = Organizations.list_organizations_by_message(message)
        {:noreply,
         socket
         |> assign(:form, to_form(changeset))
         |> assign(:organizations, organizations_list)
         |> assign(:has_search_query, has_search_query)}

      changeset ->
        changeset = Map.put(changeset, :action, :insert)
        message_value = Map.get(params, "message", "")
        has_search_query = String.trim(message_value) != ""

        {:noreply,
         socket
         |> assign(:form, to_form(changeset))
         |> assign(:has_search_query, has_search_query)}
    end
  end

  def handle_event("show_all_tags", _, socket) do
    {:noreply, assign(socket, :show_all_tags, true)}
  end

  def handle_event("select_tag", %{"tag" => tag}, socket) do
    current_message = socket.assigns.form[:message].value || ""
    new_message = if String.trim(current_message) == "", do: tag, else: current_message <> ", " <> tag

    params = %{"message" => new_message}
    changeset = Messages.change_message(socket.assigns.message, params)

    organizations_list =
      if changeset.valid? do
        message = Ecto.Changeset.apply_changes(changeset)
        Organizations.list_organizations_by_message(message)
      else
        socket.assigns.organizations
      end

    {:noreply,
     socket
     |> assign(:form, to_form(changeset))
     |> assign(:organizations, organizations_list)
     |> assign(:has_search_query, true)}
  end

  def handle_event("show_organization", %{"id" => id}, socket) do
    id = String.to_integer(id)
    organization = Organizations.get_organization!(id)

    {:noreply,
     socket
     |> assign(:organization, organization)
     |> assign(:live_action, :show)}
  end

  def handle_event("close_modal", _params, socket) do
    {:noreply, assign(socket, :live_action, nil)}
  end

  def zone_list,
    do: Enum.map(1..95, &String.pad_leading(Integer.to_string(&1), 2, "0"))

  def keywords do
    Tags.list_tags()
    |> Tags.to_keywords()
  end
end
