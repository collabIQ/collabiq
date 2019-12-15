defmodule Collabiq.Session do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Collabiq.{Agent, Repo, UUID}


  @schema_name :session
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sessions" do
    field(:ip_address, :string, default: nil)
    field(:tenant_id, :binary_id)

    belongs_to(:agent, Agent)

    timestamps(inserted_at: :created_at, type: :utc_datetime)
  end

  ### Changesets ###

  @optional [:ip_address]
  @required [:tenant_id, :agent_id]

  def cs(%__MODULE__{} = session, attrs) do
    session
    |> cast(attrs, @optional ++ @required)
    |> validate_required(@required)
    |> foreign_key_constraint(:tenant_id)
    |> foreign_key_constraint(:agent_id)
  end

  ### API Functions ###
  def create(agent) do
    attrs = %{agent_id: agent.id, tenant_id: agent.tenant_id}

    with change <- cs(%__MODULE__{}, attrs),
         :ok <- Repo.validate_change(change),
         {:ok, session} <- Repo.put(change),
         {:ok, session} <- preload_session_agent_info(session),
         {:ok, session_map} <- format_session(session) do
      {:ok, session_map}
    else
      error ->
        error
    end
  end

  defp format_session(%__MODULE__{} = session) do
    {:ok,
     %{
       id: session.id,
       t_id: session.tenant_id,
       name: session.agent.name,
       u_id: session.agent.id,
       admin_perms: Map.from_struct(session.agent.admin_role.perms),
       work_perms: Enum.map(session.agent.sites_work_roles, fn x -> %{x.site_id => Map.from_struct(x.perms)} end)
     }}
  end

  def get(id) do
    with {:ok, session} <-
           __MODULE__
           |> where([q], q.id == ^id)
           |> Repo.one()
           |> Repo.validate_read(@schema_name),
         {:ok, session} <- preload_session_agent_info(session),
         {:ok, session} <- format_session(session) do
      {:ok, session}
    else
      error ->
        error
    end
  end

  defp preload_session_agent_info(session) do
    session =
      session
      |> Repo.preload([:agent, agent: :admin_role, agent: :sites_work_roles])

    {:ok, session}
  end
end
