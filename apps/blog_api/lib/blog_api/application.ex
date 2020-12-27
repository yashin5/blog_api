defmodule BlogApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      BlogApi.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: BlogApi.PubSub}
      # Start a worker by calling: BlogApi.Worker.start_link(arg)
      # {BlogApi.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: BlogApi.Supervisor)
  end
end
