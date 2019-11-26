defmodule CollabiqWeb.ProxyResolver do
  def create(_, %{input: attrs}, %{context: %{session: sess}}) do
    case Collabiq.create_proxy(attrs, sess) do
      {:ok, result} ->
        {:ok, result}

      {:error, errors} ->
        {:error, errors}
    end
  end

  def delete(_, %{input: %{id: id}}, %{context: %{session: sess}}) do
    case Collabiq.delete_proxy(id, sess) do
      {:ok, result} ->
        {:ok, result}

      {:error, errors} ->
        {:error, errors}
    end
  end

  def disable(_, %{input: %{id: id}}, %{context: %{session: sess}}) do
    case Collabiq.disable_proxy(id, sess) do
      {:ok, result} ->
        {:ok, result}

      {:error, errors} ->
        {:error, errors}
    end
  end

  def enable(_, %{input: %{id: id}}, %{context: %{session: sess}}) do
    case Collabiq.enable_proxy(id, sess) do
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

    case Collabiq.get_proxy(id, sess, opts) do
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

    case Collabiq.list_proxies(attrs, sess, opts) do
      {:ok, result} ->
        {:ok, result}

      {:error, errors} ->
        {:error, errors}
    end
  end

  def purge(_, %{input: %{id: id}}, %{context: %{session: sess}}) do
    case Collabiq.purge_proxy(id, sess, [id: :binary_id]) do
      {:ok, result} ->
        {:ok, result}

      {:error, errors} ->
        {:error, errors}
    end
  end

  def update(_, %{input: attrs}, %{context: %{session: sess}}) do
    case Collabiq.update_proxy(attrs, sess) do
      {:ok, result} ->
        {:ok, result}

      {:error, errors} ->
        {:error, errors}
    end
  end
end
