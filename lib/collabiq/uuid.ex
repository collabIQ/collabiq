defmodule Collabiq.UUID do
  alias Collabiq.Error

  def base64_in(list) when is_list(list) do
    list
    |> Enum.map(&base64_in/1)
  end

  def base64_in(struct) when is_map(struct) do
    struct
    |> Enum.reduce(%{errors: []}, fn
      {key, id}, %{errors: errors} = acc when key in ["id", :id, "proxy_id", :proxy_id, "site_id", :site_id] ->
        case validate_base64_id(id, key) do
          {:ok, id} ->
            Map.put(acc, key, id)

          {:error, error} ->
            Map.put(acc, :errors, [ error | errors ])
        end

      {key, value}, acc ->
        Map.put(acc, key, value)
    end)
    |> case do
      %{errors: []} = struct->
        {:ok, Map.drop(struct, [:errors])}

      %{errors: errors} ->
        {:error, errors}
    end
  end

  def base64_in(id) when is_binary(id) do
    with {:ok, id} <- Base.url_decode64(id, padding: false),
         {:ok, id} <- validate_id(id) do
      {:ok, id}
    else
      _ ->
        Error.message(:id, :invalid)
    end
  end

  # def base64_in(%{id: id} = struct) when is_map(struct) do
  #   {:ok, id} = Base.url_decode64(id, padding: false)
  #   Map.put(struct, :id, id)
  # end

  def base64_out(list) when is_list(list) do
    list
    |> Enum.map(&base64_out/1)
  end

  def base64_out(struct) when is_map(struct) do
    struct
    |> Map.from_struct()
    |> Enum.reduce(%{}, fn
      {:id, id}, acc when not is_nil(id) ->
        Map.put(acc, :id, Base.url_encode64(id, padding: false))

      {:proxy_id, proxy_id}, acc when not is_nil(proxy_id) ->
        Map.put(acc, :proxy_id, Base.url_encode64(proxy_id, padding: false))


      {:site_id, site_id}, acc when not is_nil(site_id) ->
        Map.put(acc, :site_id, Base.url_encode64(site_id, padding: false))

      {key, value}, acc ->
        Map.put(acc, key, value)
    end)
  end

  def base64_out(id) when is_binary(id) do
    Base.url_encode64(id, padding: false)
  end

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

  def validate_base64_id(id, key) do
    with {:ok, id} <- Base.url_decode64(id, padding: false),
         {:ok, id} <- validate_id(id) do
      {:ok, id}
    else
      _ ->
        Error.message(key, :invalid, :error)
    end
  end

  def validate_id(%{id: id}), do: validate_id(id)

  def validate_id(%{"id" => id}), do: validate_id(id)

  def validate_id(id) do
    case Ecto.UUID.cast(id) do
      {:ok, id} ->
        {:ok, id}

      _ ->
        Error.message(:id, :invalid)
    end
  end
end
