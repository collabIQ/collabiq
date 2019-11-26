defmodule CollabiqWeb.DirectoryResolver do
  def create(_, %{input: attrs}, %{context: %{session: sess}}) do
    case Collabiq.create_directory(attrs, sess) do
      {:ok, result} ->
        {:ok, result}

      {:error, errors} ->
        {:error, errors}
    end
  end

  def delete(_, %{input: %{id: id}}, %{context: %{session: sess}}) do
    case Collabiq.delete_directory(id, sess) do
      {:ok, result} ->
        {:ok, result}

      {:error, errors} ->
        {:error, errors}
    end
  end

  def disable(_, %{input: %{id: id}}, %{context: %{session: sess}}) do
    case Collabiq.disable_directory(id, sess) do
      {:ok, result} ->
        {:ok, result}

      {:error, errors} ->
        {:error, errors}
    end
  end

  def enable(_, %{input: %{id: id}}, %{context: %{session: sess}}) do
    case Collabiq.enable_directory(id, sess) do
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

    case Collabiq.get_directory(id, sess, opts) do
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

    case Collabiq.list_directories(attrs, sess, opts) do
      {:ok, result} ->
        {:ok, result}

      {:error, errors} ->
        {:error, errors}
    end
  end

  def purge(_, %{input: %{id: id}}, %{context: %{session: sess}}) do
    case Collabiq.purge_directory(id, sess, [id: :binary_id]) do
      {:ok, result} ->
        {:ok, result}

      {:error, errors} ->
        {:error, errors}
    end
  end

  def update(_, %{input: attrs}, %{context: %{session: sess}}) do
    case Collabiq.update_directory(attrs, sess) do
      {:ok, result} ->
        {:ok, result}

      {:error, errors} ->
        {:error, errors}
    end
  end
end
