defmodule CollabiqWeb.IDTranslator do
  @behaviour Absinthe.Relay.Node.IDTranslator

  def to_global_id(_, source_id, _schema) do
    {:ok, "#{source_id}"}
  end

  def from_global_id(global_id, _schema) do
    case String.split(global_id, ":", parts: 2) do
      [type_name, source_id] ->
        {:ok, type_name, source_id}
      _ ->
        {:error, "Could not extract value from ID `#{inspect global_id}`"}
    end
  end
end
