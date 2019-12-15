defmodule CollabiqWeb.SiteController do
  use CollabiqWeb, :controller
  alias Collabiq.{Response, UUID}

  # action_fallback CollabiqWeb.FallbackController

  def create(%{assigns: %{context: %{session: sess}}} = conn, %{"site" => attrs}) do
    with {:ok, attrs} <- UUID.base64_in(attrs),
         {:ok, object} <- Collabiq.create_site(attrs, sess),
         {:ok, response} = Response.return(:site, :created, object) do
      render(conn, "mutate.json", %{site: object, response: response})
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end

  def delete(%{assigns: %{context: %{session: sess}}} = conn, %{"id" => id}) do
    with {:ok, id} <- UUID.base64_in(id),
         {:ok, object} <- Collabiq.delete_site(id, sess),
         {:ok, response} = Response.return(:site, :deleted, object) do
      render(conn, "mutate.json", %{site: object, response: response})
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end

  def disable(%{assigns: %{context: %{session: sess}}} = conn, %{"id" => id}) do
    with {:ok, id} <- UUID.base64_in(id),
         {:ok, object} <- Collabiq.disable_site(id, sess),
         {:ok, response} = Response.return(:site, :disabled, object) do
      render(conn, "mutate.json", %{site: object, response: response})
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end

  def enable(%{assigns: %{context: %{session: sess}}} = conn, %{"id" => id}) do
    with {:ok, id} <- UUID.base64_in(id),
         {:ok, object} <- Collabiq.enable_site(id, sess),
         {:ok, response} = Response.return(:site, :enabled, object) do
      render(conn, "mutate.json", %{site: object, response: response})
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end

  def list(%{assigns: %{context: %{session: sess}}} = conn, _params) do
    with {:ok, objects} <- Collabiq.list_sites(%{}, sess) do
      render(conn, "index.json", sites: objects)
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end

  def get(%{assigns: %{context: %{session: sess}}} = conn, %{"id" => id}) do
    with {:ok, id} <- UUID.base64_in(id),
         {:ok, object} <- Collabiq.get_site(id, sess) do
      render(conn, "show.json", site: object)
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end

  def purge(%{assigns: %{context: %{session: sess}}} = conn, %{"id" => id}) do
    with {:ok, id} <- UUID.base64_in(id),
         {:ok, object} <- Collabiq.purge_site(id, sess),
         {:ok, response} = Response.return(:site, :purged, object) do
      render(conn, "mutate.json", %{site: object, response: response})
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end

  def update(%{assigns: %{context: %{session: sess}}} = conn, %{"id" => id, "site" => attrs}) do
    attrs = Map.put(attrs, "id", id)

    with {:ok, attrs} <- UUID.base64_in(attrs),
         {:ok, object} <- Collabiq.update_site(attrs, sess),
         {:ok, response} = Response.return(:site, :updated, object) do
      render(conn, "mutate.json", %{site: object, response: response})
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end
end
