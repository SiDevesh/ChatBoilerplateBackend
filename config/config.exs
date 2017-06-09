# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :eop_chat_backend,
  ecto_repos: [EopChatBackend.Repo]

# Configures the endpoint
config :eop_chat_backend, EopChatBackend.Endpoint,
  url: [host: "localhost"],
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  render_errors: [view: EopChatBackend.ErrorView, accepts: ~w(html json)],
  pubsub: [name: EopChatBackend.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :eop_chat_backend, :auth0,
  app_baseurl: "thecodis.auth0.com",
  app_id: System.get_env("AUTH0_ID"),
  app_secret: System.get_env("AUTH0_SECRET")

config :guardian, Guardian,
  allowed_algos: ["HS256"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: System.get_env("AUTH0_DOMAIN"),
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: false, # doesn't work if this is true
  secret_key: System.get_env("AUTH0_SECRET"),
  serializer: EopChatBackend.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
