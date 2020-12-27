# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :blog_api,
  ecto_repos: [BlogApi.Repo]

config :blog_api_web,
  ecto_repos: [BlogApi.Repo],
  generators: [context_app: :blog_api]

# Configures the endpoint
config :blog_api_web, BlogApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6UieQC4NTsjlATOFGIUs1HqE/asqT+lVKRKfQ96Bmf2im7DDE8uOTb+fQYgyJYGY",
  render_errors: [view: BlogApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: BlogApi.PubSub,
  live_view: [signing_salt: "j+t96tCX"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
