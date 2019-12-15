ExUnit.start()
if Application.get_env(:collabiq, Collabiq.Repo)[:type] == "mysql" do
  Ecto.Adapters.SQL.Sandbox.mode(Collabiq.MyRepo, :manual)
else
  Ecto.Adapters.SQL.Sandbox.mode(Collabiq.PgRepo, :manual)
end
