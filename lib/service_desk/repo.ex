defmodule ServiceDesk.Repo do
  use Ecto.Repo,
    otp_app: :service_desk,
    adapter: Ecto.Adapters.Postgres
end
