# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :app,
  ecto_repos: [App.Repo]

config :plug,
  validate_header_keys_during_test: false

# Configures the endpoint
config :app, AppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "juawRIBEjtWsF+zzQQZLbpFt3iFm6z4DsREoWebQ7PMOfCaXeZEih8yjMgzB/HMu",
  render_errors: [view: AppWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: App.PubSub,
  live_view: [signing_salt: "lMJeDYrt"]

config :joken,
  default_signer:
    System.get_env("SECRET_KEY_BASE") ||
      "juawRIBEjtWsF+zzQQZLbpFt3iFm6z4DsREoWebQ7PMOfCaXeZEih8yjMgzB/HMu"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
