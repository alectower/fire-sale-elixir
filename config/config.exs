# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :fire_sale, FireSale.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "surqZSNgGZeT2iFaDblYdFG32iFdilv0ejF691R5ITi01PyBQP0qm2o5pXjJX90R",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: FireSale.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :template_engines,
  haml: PhoenixHaml.Engine

config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "FireSale",
  ttl: { 30, :days},
  verify_issuer: true,
  secret_key: "yk10YXLiMcQQTe7UrSuMLpy/j4q/AIQ9H5JBK0vnFNBGT3RzFoQ8fAUsNda3n5e8",
  serializer: FireSale.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
