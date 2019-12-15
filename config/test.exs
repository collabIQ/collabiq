use Mix.Config

# Configure your database
config :collabiq, Collabiq.Repo,
  type: "pgsql"

config :collabiq, Collabiq.PgRepo,
  username: "root",
  password: "root",
  database: "collabiq_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  name: :my_repo

config :collabiq, Collabiq.PgRepo,
  username: "postgres",
  password: "postgres",
  database: "collabiq_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  name: :pg_repo

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :collabiq, CollabiqWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
