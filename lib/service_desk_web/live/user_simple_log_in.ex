defmodule ServiceDeskWeb.SimpleLoginLive do
  use ServiceDeskWeb, :live_view

  alias ServiceDesk.Accounts
  alias ServiceDesk.Accounts.UserNotifier
  
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
      Conncter vous a votre espace
      <:subtitle>
      Pour vous connecter, saississez votre adresse email. Si vous etes connu...
        </:subtitle>
      </.header>

      <.simple_form for={@form} id="login_form" phx-update="ignore" phx-submit="send" phx-debounce="1000" >
        <.input field={@form[:email]} type="email" label="Email" required />
        <:actions>
          <.button> <.icon name="hero-arrow-long-right" /></.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok,
     socket
     |> assign(form: form)
     |> assign(:login, false),
     temporary_assigns: [form: form]}
  end

  def handle_event("send", %{"user" => %{"email" => email}}, socket) do
    case Accounts.get_user_by_email(email) do
      nil -> {:noreply, socket}
      user ->
	{:ok, pin} = Accounts.create_pin(user)
	UserNotifier.deliver_pin_code(user, pin.pin)
	pin.pin
	|> Integer.to_string()
	|> String.pad_leading(6, "0")
	|> IO.inspect()
	
	{:noreply, redirect(socket, to: ~p"/log_in/#{Integer.to_string(pin.puid)}")}
    end
  end
end
