defmodule Ludy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LudyWeb.Telemetry,
      Ludy.Repo,
      {DNSCluster, query: Application.get_env(:ludy, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Ludy.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Ludy.Finch},
      # Start a worker by calling: Ludy.Worker.start_link(arg)
      # {Ludy.Worker, arg},
      # Start to serve requests, typically the last entry
      LudyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ludy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LudyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
