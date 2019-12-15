defmodule CollabiqWeb.ProxyController do
  use CollabiqWeb, :controller
  alias Collabiq.{Response, UUID}

  # action_fallback CollabiqWeb.FallbackController

  def create(%{assigns: %{context: %{session: sess}}} = conn, %{"proxy" => attrs}) do
    with {:ok, attrs} <- UUID.base64_in(attrs),
         {:ok, object} <- Collabiq.create_proxy(attrs, sess),
         {:ok, response} = Response.return(:proxy, :created, object) do
      render(conn, "mutate.json", %{proxy: object, response: response})
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end

  def delete(%{assigns: %{context: %{session: sess}}} = conn, %{"id" => id}) do
    with {:ok, id} <- UUID.base64_in(id),
         {:ok, object} <- Collabiq.delete_proxy(id, sess),
         {:ok, response} = Response.return(:proxy, :deleted, object) do
      render(conn, "mutate.json", %{proxy: object, response: response})
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end

  def disable(%{assigns: %{context: %{session: sess}}} = conn, %{"id" => id}) do
    with {:ok, id} <- UUID.base64_in(id),
         {:ok, object} <- Collabiq.disable_proxy(id, sess),
         {:ok, response} = Response.return(:proxy, :disabled, object) do
      render(conn, "mutate.json", %{proxy: object, response: response})
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end

  def enable(%{assigns: %{context: %{session: sess}}} = conn, %{"id" => id}) do
    with {:ok, id} <- UUID.base64_in(id),
         {:ok, object} <- Collabiq.enable_proxy(id, sess),
         {:ok, response} = Response.return(:proxy, :enabled, object) do
      render(conn, "mutate.json", %{proxy: object, response: response})
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end

  def list(%{assigns: %{context: %{session: sess}}} = conn, _params) do
    with {:ok, objects} <- Collabiq.list_proxies(%{}, sess) do
      render(conn, "index.json", proxies: objects)
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end

  def get(%{assigns: %{context: %{session: sess}}} = conn, %{"id" => id}) do
    with {:ok, id} <- UUID.base64_in(id),
         {:ok, object} <- Collabiq.get_proxy(id, sess) do
      render(conn, "show.json", proxy: object)
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end

  def purge(%{assigns: %{context: %{session: sess}}} = conn, %{"id" => id}) do
    with {:ok, id} <- UUID.base64_in(id),
         {:ok, object} <- Collabiq.purge_proxy(id, sess),
         {:ok, response} = Response.return(:proxy, :purged, object) do
      render(conn, "mutate.json", %{proxy: object, response: response})
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end

  def update(%{assigns: %{context: %{session: sess}}} = conn, %{"id" => id, "proxy" => attrs}) do
    attrs = Map.put(attrs, "id", id)

    with {:ok, attrs} <- UUID.base64_in(attrs),
         {:ok, object} <- Collabiq.update_proxy(attrs, sess),
         {:ok, response} = Response.return(:proxy, :updated, object) do
      render(conn, "mutate.json", %{proxy: object, response: response})
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end
end
