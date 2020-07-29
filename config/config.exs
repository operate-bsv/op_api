# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :op_api,
  ecto_repos: [OpApi.Repo]

# Configures the endpoint
config :op_api, OpApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wkKgDQ7DXi9JZSdBtV0IsTnHRUjhYclYSze/eFaAl2jnoKDXv/D1lvAJQeikBRpa",
  render_errors: [view: OpApiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: OpApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
