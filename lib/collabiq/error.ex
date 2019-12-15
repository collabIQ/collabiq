defmodule Collabiq.Error do
  @moduledoc false

  def body(body) do
    case body do
      :auth -> "not authorized"
      :create -> "could not be created"
      :delete -> "could not be deleted"
      :disable -> "could not be disabled"
      :incorrect -> "is incorrect"
      :invalid -> "is invalid"
      :not_found -> "not found"
      :update -> "could not be updated"
      _ -> "something went wrong"
    end
  end

  def changeset_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&format_error/1)
    |> Enum.map(fn {key, value} ->
      %{message: to_string(key) <> " " <> to_string(value), code: "data"}
    end)
  end

  def format_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end

  def message(%Ecto.Changeset{} = changeset) do
    error_list =
      changeset
      |> changeset_errors()

    {:error, error_list}
  end

  def message(key \\ :oops, body, code \\ :error) do
    {:error, [%{message: to_string(key) <> " " <> body(body), code: to_string(code)}]}
  end

  def message() do
    {:error, [%{message: "oops something went wrong", code: "error"}]}
  end
end
