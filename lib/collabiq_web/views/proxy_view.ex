defmodule CollabiqWeb.ProxyView do
  use CollabiqWeb, :view
  alias Collabiq.UUID

  def render("error.json", %{errors: errors}) do
    %{errors: errors}
  end

  def render("index.json", %{proxies: proxies}) do
    %{data: %{proxies: render_many(proxies, __MODULE__, "proxy.json")}}
  end

  def render("mutate.json", %{proxy: proxy, response: response}) do
    %{data: %{proxy: render_one(proxy, __MODULE__, "proxy.json"), response: response}}
  end

  def render("show.json", %{proxy: proxy}) do
    %{data: %{proxy: render_one(proxy, __MODULE__, "proxy.json")}}
  end

  def render("proxy.json", %{proxy: proxy}) do
    proxy = UUID.base64_out(proxy)

    %{
      id: proxy.id,
      name: proxy.name,
      description: proxy.description,
      status: proxy.status,
      created_at: proxy.created_at,
      updated_at: proxy.updated_at,
      deleted_at: proxy.deleted_at
    }
  end
end
