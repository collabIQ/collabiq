defmodule CollabiqWeb.SiteView do
  use CollabiqWeb, :view
  alias Collabiq.UUID

  def render("error.json", %{errors: errors}) do
    %{errors: errors}
  end

  def render("index.json", %{sites: sites}) do
    %{data: %{sites: render_many(sites, __MODULE__, "site.json")}}
  end

  def render("mutate.json", %{site: site, response: response}) do
    %{data: %{site: render_one(site, __MODULE__, "site.json"), response: response}}
  end

  def render("show.json", %{site: site}) do
    %{data: %{site: render_one(site, __MODULE__, "site.json")}}
  end

  def render("site.json", %{site: site}) do
    site = UUID.base64_out(site)

    %{
      id: site.id,
      name: site.name,
      description: site.description,
      status: site.status,
      created_at: site.created_at,
      updated_at: site.updated_at,
      deleted_at: site.deleted_at
    }
  end
end
