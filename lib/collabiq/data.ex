defmodule Collabiq.Data do
  import Ecto.Query, warn: false
  alias Collabiq.{Query, Repo, Site}

  def dataloader(default_params) do
    Dataloader.Ecto.new(Repo, query: &dataloader_query/2, default_params: default_params)
  end

  def dataloader_query(Site = query, %{session: sess} = attrs) do
    attrs = Map.drop(attrs, [:session])

    query
    |> Query.site_scope(sess, :site)
    |> Query.filter(attrs, :site)
    |> Query.sort(attrs, :site)
  end

  def dataloader_query(query, _args) do
    query
  end
end
