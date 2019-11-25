defmodule Collabiq.SitePermission do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:create_group, :boolean, default: false)
    field(:create_ou, :boolean, default: false)
    field(:create_user, :boolean, default: false)
  end

  @attrs [
    :create_group,
    :create_ou,
    :create_user
  ]

  def cs(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @attrs)
    |> validate_required(@attrs)
  end
end
