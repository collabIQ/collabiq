defmodule Collabiq do
  @moduledoc false
  alias Collabiq.{AdminRole, Agent, Directory, Proxy, Session, Site, WorkRole}

  ### AdminRole Functions ###
  defdelegate create_admin_role(attrs, sess), to: AdminRole, as: :create
  defdelegate delete_admin_role(id, sess), to: AdminRole, as: :delete
  defdelegate disable_admin_role(id, sess), to: AdminRole, as: :disable
  defdelegate enable_admin_role(id, sess), to: AdminRole, as: :enable
  defdelegate get_admin_role(id, sess), to: AdminRole, as: :get
  defdelegate list_admin_roles(attrs, sess), to: AdminRole, as: :list
  defdelegate purge_admin_role(id, sess), to: AdminRole, as: :purge
  defdelegate update_admin_role(id, sess), to: AdminRole, as: :update

  ### Agent Functions ###
  defdelegate create_agent(attrs, sess), to: Agent, as: :create
  defdelegate delete_agent(id, sess), to: Agent, as: :delete
  defdelegate disable_agent(id, sess), to: Agent, as: :disable
  defdelegate enable_agent(id, sess), to: Agent, as: :enable
  defdelegate get_agent(id, sess), to: Agent, as: :get
  defdelegate list_agents(attrs, sess), to: Agent, as: :list
  defdelegate purge_agent(id, sess), to: Agent, as: :purge
  defdelegate update_agent(id, sess), to: Agent, as: :update

  ### Directory Functions ###
  defdelegate create_directory(attrs, sess), to: Directory, as: :create
  defdelegate delete_directory(id, sess), to: Directory, as: :delete
  defdelegate disable_directory(id, sess), to: Directory, as: :disable
  defdelegate enable_directory(id, sess), to: Directory, as: :enable
  defdelegate get_directory(id, sess), to: Directory, as: :get
  defdelegate list_directories(attrs, sess), to: Directory, as: :list
  defdelegate purge_directory(id, sess), to: Directory, as: :purge
  defdelegate update_directory(id, sess), to: Directory, as: :update

  ### Proxy Functions ###
  defdelegate create_proxy(attrs, sess), to: Proxy, as: :create
  defdelegate delete_proxy(id, sess), to: Proxy, as: :delete
  defdelegate disable_proxy(id, sess), to: Proxy, as: :disable
  defdelegate enable_proxy(id, sess), to: Proxy, as: :enable
  defdelegate get_proxy(id, sess), to: Proxy, as: :get
  defdelegate list_proxies(attrs, sess), to: Proxy, as: :list
  defdelegate purge_proxy(id, sess), to: Proxy, as: :purge
  defdelegate update_proxy(id, sess), to: Proxy, as: :update

  ### Session Functions ###
  defdelegate create_session(agent), to: Session, as: :create
  defdelegate get_session(id), to: Session, as: :get

  ### Site Functions ###
  defdelegate create_site(attrs, sess), to: Site, as: :create
  defdelegate delete_site(id, sess), to: Site, as: :delete
  defdelegate disable_site(id, sess), to: Site, as: :disable
  defdelegate enable_site(id, sess), to: Site, as: :enable
  defdelegate get_site(id, sess), to: Site, as: :get
  defdelegate list_sites(attrs, sess), to: Site, as: :list
  defdelegate purge_site(id, sess), to: Site, as: :purge
  defdelegate update_site(id, sess), to: Site, as: :update

  ### WorkRole Functions ###
  defdelegate create_work_role(attrs, sess), to: WorkRole, as: :create
  defdelegate delete_work_role(id, sess), to: WorkRole, as: :delete
  defdelegate disable_work_role(id, sess), to: WorkRole, as: :disable
  defdelegate enable_work_role(id, sess), to: WorkRole, as: :enable
  defdelegate get_work_role(id, sess), to: WorkRole, as: :get
  defdelegate list_work_roles(attrs, sess), to: WorkRole, as: :list
  defdelegate purge_work_role(id, sess), to: WorkRole, as: :purge
  defdelegate update_work_role(id, sess), to: WorkRole, as: :update
end
