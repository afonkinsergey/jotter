defmodule Jotter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Jotter.Repo,
      # Starts a worker by calling: Jotter.Worker.start_link(arg)
      # {Jotter.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Jotter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end