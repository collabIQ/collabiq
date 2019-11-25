defmodule Collabiq.Repo do
  use Ecto.Repo,
    otp_app: :collabiq,
    adapter: Ecto.Adapters.Postgres

  alias Collabiq.{Error, UUID}

  def put(changeset) do
    case __MODULE__.insert_or_update(changeset) do
      {:ok, result} ->
        {:ok, replace_id_in_struct(result)}

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
        {:ok, change}

      _ ->
        Error.message(change)
    end
  end

  def validate_read(data, type) do
    case data do
      %_{} ->
        {:ok, data}

      [ %_{} | _ ] ->
        {:ok, data}

      _ ->
        Error.message(type, :not_found, :error)
    end
  end
end
