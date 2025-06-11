defmodule ServiceDeskWeb.SimpleLoginLive do
  use ServiceDeskWeb, :live_view

  alias ServiceDesk.Accounts
  alias ServiceDesk.Accounts.UserNotifier

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm min-h-[60vh] flex items-center justify-center">
      <div class="w-full">
        <.header class="text-center">
        Connecter vous à votre espace
        </.header>

        <.simple_form for={@form} id="login_form" phx-update="ignore" phx-submit="send" phx-debounce="1000" >
          <div>
            <label for="user_email" class="block text-sm font-semibold leading-6 text-zinc-300">Email</label>
            <div class="mt-2 flex rounded-md shadow-sm">
              <input
                type="email"
                name="user[email]"
                id="user_email"
                value={@form[:email].value}
                required
                class="block w-full rounded-r-none rounded-l-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6 border-zinc-300 focus:border-zinc-400 py-1.5"
                placeholder="votre.email@exemple.fr"
              />
              <button
                type="submit"
                class="inline-flex items-center gap-x-1.5 rounded-r-md bg-[#0d4e62] hover:bg-[#a81616] px-3 py-1.5 text-sm font-semibold text-white"
              >
                <.icon name="hero-arrow-long-right" class="h-5 w-5" />
              </button>
            </div>
          </div>
        </.simple_form>
      </div>
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

	{:noreply, redirect(socket, to: ~p"/log_in/#{Integer.to_string(pin.puid)}")}
    end
  end
end
