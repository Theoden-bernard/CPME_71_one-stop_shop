defmodule ServiceDeskWeb.PageController do
  use ServiceDeskWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    if (conn.assigns.current_user) do
      redirect(conn, to: "/users/settings")
    else
      redirect(conn, to: "/users/log_in")
    end
  end
end
