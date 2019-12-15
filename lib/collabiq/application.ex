defmodule Collabiq.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      #Collabiq.Repo,
      # Start the endpoint when the application starts
      CollabiqWeb.Endpoint,
      {Absinthe.Subscription, [CollabiqWeb.Endpoint]}
      # Starts a worker by calling: Collabiq.Worker.start_link(arg)
      # {Collabiq.Worker, arg},
    ]

    children = if Application.get_env(:collabiq, Collabiq.Repo)[:type] == "mysql" do
      [ Collabiq.MyRepo | children ]
    else
      [ Collabiq.PgRepo | children ]
    end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Collabiq.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CollabiqWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
