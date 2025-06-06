# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :service_desk,
  ecto_repos: [ServiceDesk.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :service_desk, ServiceDeskWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: ServiceDeskWeb.ErrorHTML, json: ServiceDeskWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: ServiceDesk.PubSub,
  live_view: [signing_salt: "FzZSh4yc"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
#config :service_desk, ServiceDesk.Mailer, adapter: Swoosh.Adapters.Local

smtp_relay = System.get_env("COLINT_SMTP_SERVER") || raise "Environment variable COLINT_SMTP_SERVER is m\
issing."
smtp_port = System.get_env("COLINT_SMTP_PORT") || raise "Environment variable COLINT_SMTP_PORT is missin\
g."
smtp_username = System.get_env("COLINT_SMTP_USERNAME") || raise "Environment variable COLINT_SMTP_USERNA\
ME is missing."
smtp_password = System.get_env("COLINT_SMTP_PASSWORD") || raise "Environment variable COLINT_SMTP_PASSWO\
RD is missing."
config :service_desk, ServiceDesk.Mailer,
  adapter: Swoosh.Adapters.SMTP,
  relay: smtp_relay,
  port: smtp_port,
  username: smtp_username,
  password: smtp_password,
  tls: :always,
  auth: :always,
  tls_options: [
    versions: [:"tlsv1.2", :"tlsv1.3"],
    cacerts: :public_key.cacerts_get(),
    server_name_indication: ~c"#{smtp_relay}", # what your certificate is issued for
    depth: 64, # important or stuff may crash with - {:bad_cert, :max_path_length_reached}
  ],
  ssl: false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  service_desk: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  service_desk: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
