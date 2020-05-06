use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :pizza_party, PizzaPartyWeb.Endpoint,
  secret_key_base: "6NXZO7jHdeVO0qRCkuRhC+iPht9QnpK2JlAMnQgjYP2H2fGUloGjP8inf41yyiKz"

# Configure your database
config :pizza_party, PizzaParty.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "pizza_party_prod",
  pool_size: 15
