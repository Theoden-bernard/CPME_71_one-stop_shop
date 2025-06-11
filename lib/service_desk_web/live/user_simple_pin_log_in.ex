defmodule ServiceDeskWeb.SimplePinLoginLive do
  use ServiceDeskWeb, :live_view

  alias ServiceDesk.Accounts

  defguard is_pin(pin) when (pin == <<?0>> or pin == <<?1>> or pin == <<?2>> or pin == <<?3>> or pin == <<?4>> or pin == <<?4>> or pin == <<?5>> or pin == <<?6>> or pin == <<?7>> or pin == <<?8>> or pin == <<?9>>)
  
  def render(assigns) do
    ~H"""
    <div :if={@invalid} class="text-center text-xl text-[#a81616]"> Votre code pin est invalide </div>
    <div class="mx-auto max-w-sm">
      <.simple_form for={@form} id="login_form" phx-update="ignore" phx-change="validate" >  
        <div class="flex flex-row gap-2">
          <input
            type="text"
            name="one"
            id="one"
            value={Phoenix.HTML.Form.normalize_value("text", @form[:one].value)}
            class={[
              "mt-2 block w-full rounded-lg text-zinc-900 text-center focus:ring-0 sm:text-sm sm:leading-6",
            ]}
          />

          <input
            type="text"
            name="two"
            id="two"
            value={Phoenix.HTML.Form.normalize_value("text", @form[:two].value)}
            class={[
              "mt-2 block w-full rounded-lg text-zinc-900 text-center focus:ring-0 sm:text-sm sm:leading-6",
            ]}
          />

          <input
            type="text"
            name="three"
            id="three"
            value={Phoenix.HTML.Form.normalize_value("text", @form[:three].value)}
            class={[
              "mt-2 block w-full rounded-lg text-zinc-900 text-center focus:ring-0 sm:text-sm sm:leading-6",
            ]}
          />
                    <input
            type="text"
            name="four"
            id="four"
            value={Phoenix.HTML.Form.normalize_value("text", @form[:four].value)}
            class={[
              "mt-2 block w-full rounded-lg text-zinc-900 text-center focus:ring-0 sm:text-sm sm:leading-6",
            ]}
          />

          <input
            type="text"
            name="five"
            id="five"
            value={Phoenix.HTML.Form.normalize_value("text", @form[:five].value)}
            class={[
              "mt-2 block w-full rounded-lg text-zinc-900 text-center focus:ring-0 sm:text-sm sm:leading-6",
            ]}
          />

          <input
            type="text"
            name="six"
            id="six"
            value={Phoenix.HTML.Form.normalize_value("text", @form[:six].value)}
            class={[
              "mt-2 block w-full rounded-lg text-zinc-900 text-center focus:ring-0 sm:text-sm sm:leading-6",
            ]}
          />
        </div>
      </.simple_form>
    </div>
    """
  end

  def mount(%{"puid" => puid}, _session, socket) do
    pin = Accounts.get_pin!(puid)
    
    form = to_form(%{
	  "one" => "",
	  "two" => "",
	  "three" => "",
	  "four" => "",
	  "five" => "",
	  "six" => ""},
	  as: "pin")
    
    {:ok,
     socket
     |> assign(form: form)
     |> assign(:login, false)
     |> assign(:pin, pin)
     |> assign(:invalid, false),
     temporary_assigns: [form: form]}
  end

  def handle_event("validate", %{"one" => one,
				    "two" => two,
				    "three" => three,
				    "four" => four,
				    "five" => five,
				    "six" => six}, socket) when
  is_pin(one) and is_pin(two) and is_pin(three) and is_pin(four) and is_pin(five) and is_pin(six) do
    pin_code =
      [one, two, three, four, five, six]
      |> Enum.map(&String.to_integer(&1))
      |> Integer.undigits()

    if pin_code == socket.assigns.pin.pin do
      {:noreply,
       socket
       |> put_flash(:info, "Bienvenu dans votre espace entreprise")
       |> redirect(to: ~p"/log_in/#{socket.assigns.pin.puid}/#{pin_code}")}
    else
      {:noreply, assign(socket, :invalid, true)}
    end
  end

  def handle_event("validate", %{"_target" => [form]}, socket) do
    map =
      %{"one" => "two",
	"two" => "three",
	"three" => "four",
	"four" => "five",
	"five" => "six"}
    
    next = Map.get(map, form)
    {:noreply, push_event(socket, "focusElementById", %{id: next})}
  end
end
