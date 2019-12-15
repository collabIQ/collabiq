defmodule CollabiqWeb.DirectoryView do
  use CollabiqWeb, :view
  alias Collabiq.UUID

  def render("error.json", %{errors: errors}) do
    %{errors: errors}
  end

  def render("index.json", %{directories: directories}) do
    %{data: %{directories: render_many(directories, __MODULE__, "directory.json")}}
  end

  def render("mutate.json", %{directory: directory, response: response}) do
    %{data: %{directory: render_one(directory, __MODULE__, "directory.json"), response: response}}
  end

  def render("show.json", %{directory: directory}) do
    %{data: %{directory: render_one(directory, __MODULE__, "directory.json")}}
  end

  def render("directory.json", %{directory: directory}) do
    directory = UUID.base64_out(directory)

    %{
      id: directory.id,
      name: directory.name,
      description: directory.description,
      proxy_id: directory.proxy_id,
      server: directory.server,
      site_id: directory.site_id,
      status: directory.status,
      un: directory.un,
      created_at: directory.created_at,
      updated_at: directory.updated_at,
      deleted_at: directory.deleted_at
    }
  end
end
