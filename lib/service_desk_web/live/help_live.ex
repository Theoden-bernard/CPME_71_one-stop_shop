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
     |> assign(:message, message)}
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

  def handle_event(_, %{"message" => params}, socket) do
    case Messages.change_message(socket.assigns.message, params) do
      changeset when changeset.valid? ->
	message = Ecto.Changeset.apply_changes(changeset)
	organizations_list = Organizations.list_organizations_by_message(message)
	{:noreply,
	 socket
	 |> assign(:form, to_form(changeset))
	 |> assign(:organizations, organizations_list)}
	
      changeset ->
	changeset = Map.put(changeset, :action, :insert)
	{:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  def zone_list,
    do: Enum.map(1..95, &String.pad_leading(Integer.to_string(&1), 2, "0"))

  def keywords do
    Tags.list_tags()
    |> Tags.to_keywords()
  end
end
