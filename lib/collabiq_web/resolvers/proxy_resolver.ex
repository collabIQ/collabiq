defmodule CollabiqWeb.ProxyResolver do
  alias Collabiq.{Response, UUID}

  def create(_, %{input: attrs}, %{context: %{session: sess}}) do
    with {:ok, attrs} <- UUID.base64_in(attrs),
         {:ok, result} <- Collabiq.create_proxy(attrs, sess),
         {:ok, response} = Response.return(:proxy, :created, result) do
      {:ok, %{proxy: UUID.base64_out(result), response: response}}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end

  def delete(_, %{input: input}, %{context: %{session: sess}}) do
    with {:ok, %{id: id}} = UUID.base64_in(input),
         {:ok, result} <- Collabiq.delete_proxy(id, sess),
         {:ok, response} = Response.return(:proxy, :deleted, result) do
      {:ok, %{proxy: UUID.base64_out(result), response: response}}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end

  def disable(_, %{input: input}, %{context: %{session: sess}}) do
    with {:ok, %{id: id}} = UUID.base64_in(input),
         {:ok, result} <- Collabiq.disable_proxy(id, sess),
         {:ok, response} = Response.return(:proxy, :disabled, result) do
      {:ok, %{proxy: UUID.base64_out(result), response: response}}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end

  def enable(_, %{input: input}, %{context: %{session: sess}}) do
    with {:ok, %{id: id}} = UUID.base64_in(input),
         {:ok, result} <- Collabiq.enable_proxy(id, sess),
         {:ok, response} = Response.return(:proxy, :enabled, result) do
      {:ok, %{proxy: UUID.base64_out(result), response: response}}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end

  def get(_, attrs, %{context: %{session: sess}}) do
    with {:ok, %{id: id}} <- UUID.base64_in(attrs),
         {:ok, result} <- Collabiq.get_proxy(id, sess) do
      {:ok, UUID.base64_out(result)}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end

  def list(_, attrs, %{context: %{session: sess}}) do
    case Collabiq.list_proxies(attrs, sess) do
      {:ok, result} ->
        {:ok, UUID.base64_out(result)}

      {:error, errors} ->
        {:error, errors}
    end
  end

  def purge(_, %{input: input}, %{context: %{session: sess}}) do
    with {:ok, %{id: id}} = UUID.base64_in(input),
         {:ok, result} <- Collabiq.purge_proxy(id, sess),
         {:ok, response} = Response.return(:proxy, :purged, result) do
      {:ok, %{proxy: UUID.base64_out(result), response: response}}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end

  def update(_, %{input: input}, %{context: %{session: sess}}) do
    with {:ok, attrs} = UUID.base64_in(input),
         {:ok, result} <- Collabiq.update_proxy(attrs, sess),
         {:ok, response} = Response.return(:proxy, :updated, result) do
      {:ok, %{proxy: UUID.base64_out(result), response: response}}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end
end
