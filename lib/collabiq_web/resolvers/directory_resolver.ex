defmodule CollabiqWeb.DirectoryResolver do
  alias Collabiq.{Response, UUID}

  def create(_, %{input: attrs}, %{context: %{session: sess}}) do
    with {:ok, attrs} <- UUID.base64_in(attrs),
         {:ok, result} <- Collabiq.create_directory(attrs, sess),
         {:ok, response} = Response.return(:directory, :created, result) do
      {:ok, %{directory: UUID.base64_out(result), response: response}}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end

  def delete(_, %{input: input}, %{context: %{session: sess}}) do
    with {:ok, %{id: id}} = UUID.base64_in(input),
         {:ok, result} <- Collabiq.delete_directory(id, sess),
         {:ok, response} = Response.return(:directory, :deleted, result) do
      {:ok, %{directory: UUID.base64_out(result), response: response}}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end

  def disable(_, %{input: input}, %{context: %{session: sess}}) do
    with {:ok, %{id: id}} = UUID.base64_in(input),
         {:ok, result} <- Collabiq.disable_directory(id, sess),
         {:ok, response} = Response.return(:directory, :disabled, result) do
      {:ok, %{directory: UUID.base64_out(result), response: response}}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end

  def enable(_, %{input: input}, %{context: %{session: sess}}) do
    with {:ok, %{id: id}} = UUID.base64_in(input),
         {:ok, result} <- Collabiq.enable_directory(id, sess),
         {:ok, response} = Response.return(:directory, :enabled, result) do
      {:ok, %{directory: UUID.base64_out(result), response: response}}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end

  def get(_, attrs, %{context: %{session: sess}}) do
    with {:ok, %{id: id}} <- UUID.base64_in(attrs),
         {:ok, result} <- Collabiq.get_directory(id, sess) do
      {:ok, UUID.base64_out(result)}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end

  def list(_, attrs, %{context: %{session: sess}}) do
    case Collabiq.list_directories(attrs, sess) do
      {:ok, result} ->
        {:ok, UUID.base64_out(result)}

      {:error, errors} ->
        {:error, errors}
    end
  end

  def purge(_, %{input: input}, %{context: %{session: sess}}) do
    with {:ok, %{id: id}} = UUID.base64_in(input),
         {:ok, result} <- Collabiq.purge_directory(id, sess),
         {:ok, response} = Response.return(:directory, :purged, result) do
      {:ok, %{directory: UUID.base64_out(result), response: response}}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end

  def update(_, %{input: input}, %{context: %{session: sess}}) do
    with {:ok, attrs} = UUID.base64_in(input),
         {:ok, result} <- Collabiq.update_directory(attrs, sess),
         {:ok, response} = Response.return(:directory, :updated, result) do
      {:ok, %{directory: UUID.base64_out(result), response: response}}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end
end
