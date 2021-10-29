# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :leleglish,
  ecto_repos: [Leleglish.Repo]

# Configures the endpoint
config :leleglish, LeleglishWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VDyFNH4JBpGU4eDa2t7LSKLCyDA7y1/Zod4Ngry/xfiYPdnnqRkx9cAn74TN+GBS",
  render_errors: [view: LeleglishWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Leleglish.PubSub,
  live_view: [signing_salt: "0U/gh47h"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :env,
  GOOGLE_API_KEY: System.get_env("GOOGLE_API_KEY")
