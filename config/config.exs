# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :jotter,
  ecto_repos: [Jotter.Repo]

# Configures the endpoint
config :jotter, JotterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7cvVPruf7TCM79oDt+15bWoUnDox/Wbwa6gfeseBfGSS+E1v6EO6mkBpFFgJPjXH",
  render_errors: [view: JotterWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Jotter.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Guardian config details
# Secret key. You can use `mix guardian.gen.secret` to get one
config  :jotter, Jotter.Guardian,
  issuer: "jotter",
  secret_key: "MYN0QD1vH3Ml+H/0GXTVyrMRDoJVfr+MtpFSnWsgFQGrOpRzzou44kJJEMTCYrpV"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
