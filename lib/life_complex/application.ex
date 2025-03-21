defmodule LifeComplex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    LifeComplex.FinchLogger.attach()

    poolboy_config = [
      name: {:local, :llm_worker_pool},
      worker_module: LifeComplex.Worker,
      size: 500,
      max_overflow: 0
    ]

    children = [
      LifeComplexWeb.Telemetry,
      LifeComplex.Repo,
      {DNSCluster, query: Application.get_env(:life_complex, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LifeComplex.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LifeComplex.Finch},
      # Prometheus metrics
      LifeComplex.PromEx,
      # Start a worker by calling: LifeComplex.Worker.start_link(arg)
      # {LifeComplex.Worker, arg},
      :poolboy.child_spec(:llm_worker_pool, poolboy_config),
      # Start to serve requests, typically the last entry
      LifeComplexWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LifeComplex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LifeComplexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
