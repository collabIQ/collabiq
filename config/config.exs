# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :collabiq,
  ecto_repos: [Collabiq.MyRepo, Collabiq.PgRepo],
  generators: [binary_id: true]

# Configures the endpoint
config :collabiq, CollabiqWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qKEmiByfi0XTUGTEzVL0/We3nl7z8yu1YwtVa7f+QI/PNQc8sx4qh2LB8E+nY/SO",
  render_errors: [view: CollabiqWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Collabiq.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# config Absinthe.Relay, CollabiqWeb.Schema,
#   global_id_translator: CollabiqWeb.IDTranslator

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
