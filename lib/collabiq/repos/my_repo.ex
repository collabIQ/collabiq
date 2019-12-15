defmodule Collabiq.MyRepo do
  use Ecto.Repo,
    otp_app: :collabiq,
    adapter: Ecto.Adapters.MyXQL
end
