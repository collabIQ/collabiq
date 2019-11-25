defmodule Collabiq.Response do
  def return(key, body, %{name: name}, code \\ :ok) do
    {:ok, %{message: Atom.to_string(key) <> " " <> name <> " " <> Atom.to_string(body), code: Atom.to_string(code)}}
  end
end
