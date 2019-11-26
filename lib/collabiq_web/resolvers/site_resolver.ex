defmodule CollabiqWeb.SiteResolver do
  def create(_, %{input: attrs}, %{context: %{session: sess}}) do
    case Collabiq.create_site(attrs, sess) do
      {:ok, result} ->
        {:ok, result}

      {:error, errors} ->
        {:error, errors}
    end
  end

  def delete(_, %{input: %{id: id}}, %{context: %{session: sess}}) do
    case Collabiq.delete_site(id, sess) do
      {:ok, result} ->
        {:ok, result}

      {:error, errors} ->
        {:error, errors}
    end
  end

  def disable(_, %{input: %{id: id}}, %{context: %{session: sess}}) do
    case Collabiq.disable_site(id, sess) do
      {:ok, result} ->
        {:ok, result}

      {:error, errors} ->
        {:error, errors}
    end
  end

  def enable(_, %{input: %{id: id}}, %{context: %{session: sess}}) do
    case Collabiq.enable_site(id, sess) do
      {:ok, result} ->
        {:ok, result}

      {:error, errors} ->
        {:error, errors}
    end
  end

  def get(_, %{id: id}, %{context: %{session: sess}} = info) do
    fields =
      Absinthe.Resolution.project(info)
      |> Enum.map(&(&1.name))

    opts = Keyword.new([{:fields, fields}])

    case Collabiq.get_site(id, sess, opts) do
      {:ok, result} ->
        {:ok, result}

      {:error, errors} ->
        {:error, errors}
    end
  end

  def list(_, attrs, %{context: %{session: sess}} = info) do
    fields =
      Absinthe.Resolution.project(info)
      |> Enum.map(&(&1.name))

    opts = Keyword.new([{:fields, fields}])

    case Collabiq.list_sites(attrs, sess, opts) do
      {:ok, result} ->
        {:ok, result}

      {:error, errors} ->
        {:error, errors}
    end
  end

  def purge(_, %{input: %{id: id}}, %{context: %{session: sess}}) do
    case Collabiq.purge_site(id, sess, [id: :binary_id]) do
      {:ok, result} ->
        {:ok, result}

      {:error, errors} ->
        {:error, errors}
    end
  end

  def update(_, %{input: attrs}, %{context: %{session: sess}}) do
    case Collabiq.update_site(attrs, sess) do
      {:ok, result} ->
        {:ok, result}

      {:error, errors} ->
        {:error, errors}
    end
  end
end
