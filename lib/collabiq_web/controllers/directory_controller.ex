defmodule CollabiqWeb.DirectoryController do
  use CollabiqWeb, :controller
  alias Collabiq.{Response, UUID}

  # action_fallback CollabiqWeb.FallbackController

  def create(%{assigns: %{context: %{session: sess}}} = conn, %{"directory" => attrs}) do
    with {:ok, attrs} <- UUID.base64_in(attrs),
         {:ok, object} <- Collabiq.create_directory(attrs, sess),
         {:ok, response} = Response.return(:directory, :created, object) do
      render(conn, "mutate.json", %{directory: object, response: response})
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end

  def delete(%{assigns: %{context: %{session: sess}}} = conn, %{"id" => id}) do
    with {:ok, id} <- UUID.base64_in(id),
         {:ok, object} <- Collabiq.delete_directory(id, sess),
         {:ok, response} = Response.return(:directory, :deleted, object) do
      render(conn, "mutate.json", %{directory: object, response: response})
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end

  def disable(%{assigns: %{context: %{session: sess}}} = conn, %{"id" => id}) do
    with {:ok, id} <- UUID.base64_in(id),
         {:ok, object} <- Collabiq.disable_directory(id, sess),
         {:ok, response} = Response.return(:directory, :disabled, object) do
      render(conn, "mutate.json", %{directory: object, response: response})
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end

  def enable(%{assigns: %{context: %{session: sess}}} = conn, %{"id" => id}) do
    with {:ok, id} <- UUID.base64_in(id),
         {:ok, object} <- Collabiq.enable_directory(id, sess),
         {:ok, response} = Response.return(:directory, :enabled, object) do
      render(conn, "mutate.json", %{directory: object, response: response})
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end

  def list(%{assigns: %{context: %{session: sess}}} = conn, _params) do
    with {:ok, objects} <- Collabiq.list_directories(%{}, sess) do
      render(conn, "index.json", directories: objects)
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end

  def get(%{assigns: %{context: %{session: sess}}} = conn, %{"id" => id}) do
    with {:ok, id} <- UUID.base64_in(id),
         {:ok, object} <- Collabiq.get_directory(id, sess) do
      render(conn, "show.json", directory: object)
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end

  def purge(%{assigns: %{context: %{session: sess}}} = conn, %{"id" => id}) do
    with {:ok, id} <- UUID.base64_in(id),
         {:ok, object} <- Collabiq.purge_directory(id, sess),
         {:ok, response} = Response.return(:directory, :purged, object) do
      render(conn, "mutate.json", %{directory: object, response: response})
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end

  def update(%{assigns: %{context: %{session: sess}}} = conn, %{"id" => id, "directory" => attrs}) do
    attrs = Map.put(attrs, "id", id)

    with {:ok, attrs} <- UUID.base64_in(attrs),
         {:ok, object} <- Collabiq.update_directory(attrs, sess),
         {:ok, response} = Response.return(:directory, :updated, object) do
      render(conn, "mutate.json", %{directory: object, response: response})
    else
      {:error, errors} ->
        render(conn, "error.json", errors: errors)
    end
  end
end
