defmodule Collabiq.UUID do
  alias Collabiq.Error

  def base_to_string([ _ | _ ] = base_list) do
    base_list
    |> Enum.map(fn base_id ->
      case base_to_string(base_id) do
        {:ok, binary_id} ->
          binary_id

        _ ->
          []
      end
    end)
    |> List.flatten()
  end

  def base_to_string(base) do
    with {:ok, bin} <- url_decode(base),
         {:ok, string} <- bin_to_string(bin) do
        {:ok, string}
    else
      error ->
        error
    end
  end

  def bin_gen(), do: {:ok, Ecto.UUID.bingenerate()}

  def bin_to_string(bin) do
    bin
    |> Ecto.UUID.load()
    |> case do
      {:ok, uuid_string} ->
        {:ok, uuid_string}

      _ ->
        :error
    end
  end

  def string_gen() do
    Ecto.UUID.bingenerate()
    |> Ecto.UUID.load()
    |> case do
      {:ok, uuid_string} ->
        {:ok, uuid_string}

      _ ->
        :error
    end
  end

  def string_gen!() do
    Ecto.UUID.bingenerate()
    |> Ecto.UUID.load()
    |> case do
      {:ok, uuid_string} ->
        uuid_string

      _ ->
        :error
    end
  end

  def string_to_base(string) do
    with {:ok, bin} <- string_to_bin(string),
         {:ok, base} <- url_encode(bin) do
        {:ok, base}
    else
      error ->
        error
    end
  end

  def string_to_bin(string) do
    string
    |> Ecto.UUID.dump()
    |> case do
      {:ok, uuid_bin} ->
        {:ok, uuid_bin}

      _ ->
        :error
    end
  end

  def url_decode(base_id) do
    case Base.url_decode64(base_id, padding: false) do
      {:ok, binary_id} ->
        {:ok, binary_id}

      _ ->
        :error
    end
  end

  def url_encode(binary_id), do: {:ok, Base.url_encode64(binary_id, padding: false)}

  def validate_id(%{id: id}), do: validate_id(id)

  def validate_id(%{"id" => id}), do: validate_id(id)

  def validate_id(id) do
    case Ecto.UUID.cast(id) do
      {:ok, id} ->
        {:ok, id}

      _ ->
        case base_to_string(id) do
          {:ok, id} ->
            {:ok, id}

          _ ->
            Error.message(:id, :invalid)
        end
    end
  end
end
