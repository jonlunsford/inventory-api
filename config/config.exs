# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :inventory,
  ecto_repos: [Inventory.Repo]

# Configures the endpoint
config :inventory, Inventory.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Q0ZLrEwSsDFwQJ+N2cKTcqR4QdU6xQ1DSDjNJYJ+5rYrcoA9IL1YWDMTSHpJNi0n",
  render_errors: [view: Inventory.ErrorView, accepts: ~w(json json-api html)],
  pubsub: [name: Inventory.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :format_encoders,
  "json-api": Poison

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "Inventory",
  ttl: { 30, :days },
  verify_issuer: true,
  secret_key: System.get_env("GUARDIAN_SECRET") || "S/jyQJGbvLHyQypHJdYetsPkjNFngwoHvOVSkH83x2A9Y+XdqdebtnsdmAzN2FNM",
  serializer: Inventory.GuardianSerializer

config :hound, driver: "chrome_driver"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
