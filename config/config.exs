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
  secret_key_base: "DkIxosbRaow/1iPk3x8RMWo2uKBtjXDe8+o1TwJjZTBzHZN0KYEVDGSbWMDVxIFR",
  render_errors: [view: EopChatBackend.ErrorView, accepts: ~w(html json)],
  pubsub: [name: EopChatBackend.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :eop_chat_backend, :auth0,
  app_baseurl: "thecodis.auth0.com",
  app_id: "2VcZR3UcUz2rxzER1th6ejyMT5d7F4LE",
  app_secret: "zElYtjI2Ah0TrArD3T9LkSbWdP2B86W9_YRKSuza07wsXM3qGDV-5wZUw4xjq5Pa"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
