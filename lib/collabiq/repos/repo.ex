defmodule Collabiq.Repo do
  alias Collabiq.{Error, UUID}

  def all(queryable) do
    if Application.get_env(:collabiq, Collabiq.Repo)[:type] == "mysql" do
      Collabiq.MyRepo.all(queryable)
    else
      Collabiq.PgRepo.all(queryable)
    end
  end

  def one(queryable) do
    if Application.get_env(:collabiq, Collabiq.Repo)[:type] == "mysql" do
      Collabiq.MyRepo.one(queryable)
    else
      Collabiq.PgRepo.one(queryable)
    end
  end

  def preload(queryable, preloads) do
    if Application.get_env(:collabiq, Collabiq.Repo)[:type] == "mysql" do
      Collabiq.MyRepo.preload(queryable, preloads)
    else
      Collabiq.PgRepo.preload(queryable, preloads)
    end
  end

  def purge(changeset) do
    purge =
      if Application.get_env(:collabiq, Collabiq.Repo)[:type] == "mysql" do
        Collabiq.MyRepo.delete(changeset)
      else
        Collabiq.PgRepo.delete(changeset)
      end

    case purge do
      {:ok, struct} ->
        {:ok, struct}

      {:error, change} ->
        Error.message(change)
    end
  end

  def put(changeset) do
    put =
      if Application.get_env(:collabiq, Collabiq.Repo)[:type] == "mysql" do
        Collabiq.MyRepo.insert_or_update(changeset)
      else
        Collabiq.PgRepo.insert_or_update(changeset)
      end

    case put do
      {:ok, struct} ->
        {:ok, struct}

      {:error, change} ->
        Error.message(change)
    end
  end

  def replace_id_in_struct(struct) do
    with {:ok, base_id} <- UUID.string_to_base(struct.id),
         result <- Map.put(struct, :id, base_id) do
      result
    else
      error ->
        error
    end
  end

  def replace_ids_in_list(list) do
    list
    |> Enum.map(&replace_id_in_struct/1)
  end

  def single(query, opts \\ []) do
    id = Keyword.get(opts, :id, :base_id)

    case __MODULE__.one(query) do
      nil ->
        nil

      struct ->
        if id == :base_id do
          replace_id_in_struct(struct)
        else
          struct
        end
    end
  end

  def validate_change(change) do
    case change.valid? do
      true ->
        :ok

      _ ->
        Error.message(change)
    end
  end

  def validate_read(data, type) do
    case data do
      %_{} ->
        {:ok, data}

      [%_{} | _] ->
        {:ok, data}

      _ ->
        Error.message(type, :not_found, :error)
    end
  end
end
