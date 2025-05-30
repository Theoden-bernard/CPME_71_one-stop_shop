defmodule ServiceDesk.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ServiceDeskWeb.Telemetry,
      ServiceDesk.Repo,
      {DNSCluster, query: Application.get_env(:service_desk, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ServiceDesk.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ServiceDesk.Finch},
      # Start a worker by calling: ServiceDesk.Worker.start_link(arg)
      # {ServiceDesk.Worker, arg},
      # Start to serve requests, typically the last entry
      ServiceDeskWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ServiceDesk.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ServiceDeskWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
