defmodule CollabiqWeb.SiteResolver do
  alias Collabiq.{Response, UUID}

  def create(_, %{input: attrs}, %{context: %{session: sess}}) do
    with {:ok, attrs} <- UUID.base64_in(attrs),
         {:ok, result} <- Collabiq.create_site(attrs, sess),
         {:ok, response} = Response.return(:site, :created, result) do
      {:ok, %{site: UUID.base64_out(result), response: response}}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end

  def delete(_, %{input: input}, %{context: %{session: sess}}) do
    with {:ok, %{id: id}} = UUID.base64_in(input),
         {:ok, result} <- Collabiq.delete_site(id, sess),
         {:ok, response} = Response.return(:site, :deleted, result) do
      {:ok, %{site: UUID.base64_out(result), response: response}}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end

  def disable(_, %{input: input}, %{context: %{session: sess}}) do
    with {:ok, %{id: id}} = UUID.base64_in(input),
         {:ok, result} <- Collabiq.disable_site(id, sess),
         {:ok, response} = Response.return(:site, :disabled, result) do
      {:ok, %{site: UUID.base64_out(result), response: response}}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end

  def enable(_, %{input: input}, %{context: %{session: sess}}) do
    with {:ok, %{id: id}} = UUID.base64_in(input),
         {:ok, result} <- Collabiq.enable_site(id, sess),
         {:ok, response} = Response.return(:site, :enabled, result) do
      {:ok, %{site: UUID.base64_out(result), response: response}}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end

  def get(_, attrs, %{context: %{session: sess}}) do
    with {:ok, %{id: id}} <- UUID.base64_in(attrs),
         {:ok, result} <- Collabiq.get_site(id, sess) do
      {:ok, UUID.base64_out(result)}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end

  def list(_, attrs, %{context: %{session: sess}}) do
    case Collabiq.list_sites(attrs, sess) do
      {:ok, result} ->
        {:ok, UUID.base64_out(result)}

      {:error, errors} ->
        {:error, errors}
    end
  end

  def purge(_, %{input: input}, %{context: %{session: sess}}) do
    with {:ok, %{id: id}} = UUID.base64_in(input),
         {:ok, result} <- Collabiq.purge_site(id, sess),
         {:ok, response} = Response.return(:site, :purged, result) do
      {:ok, %{site: UUID.base64_out(result), response: response}}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end

  def update(_, %{input: input}, %{context: %{session: sess}}) do
    with {:ok, attrs} = UUID.base64_in(input),
         {:ok, result} <- Collabiq.update_site(attrs, sess),
         {:ok, response} = Response.return(:site, :updated, result) do
      {:ok, %{site: UUID.base64_out(result), response: response}}
    else
      {:error, errors} ->
        {:error, errors}
    end
  end
end
