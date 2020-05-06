# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :pizza_party,
  ecto_repos: [PizzaParty.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :pizza_party, PizzaPartyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VJd7Qx5unIp55lZUAMLlWa/N41Q2RD310yAHEC+ps38geDJE2zHJbOzGN1zXtP2X",
  render_errors: [view: PizzaPartyWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PizzaParty.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
