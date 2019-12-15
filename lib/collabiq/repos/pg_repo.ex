defmodule Collabiq.PgRepo do
  use Ecto.Repo,
    otp_app: :collabiq,
    adapter: Ecto.Adapters.Postgres
end
