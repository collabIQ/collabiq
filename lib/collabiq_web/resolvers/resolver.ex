defmodule CollabiqWeb.Resolver do
  alias CollabiqWeb.{DirectoryResolver, ProxyResolver, SiteResolver}

  ### Directory Functions ###
  defdelegate create_directory(parent, attrs, sess), to: DirectoryResolver, as: :create
  defdelegate delete_directory(parent, id, sess), to: DirectoryResolver, as: :delete
  defdelegate disable_directory(parent, id, sess), to: DirectoryResolver, as: :disable
  defdelegate enable_directory(parent, id, sess), to: DirectoryResolver, as: :enable
  defdelegate get_directory(parent, id, sess), to: DirectoryResolver, as: :get
  defdelegate list_directories(parent, attrs, sess), to: DirectoryResolver, as: :list
  defdelegate purge_directory(parent, id, sess), to: DirectoryResolver, as: :purge
  defdelegate update_directory(parent, id, sess), to: DirectoryResolver, as: :update

  ### Proxy Functions ###
  defdelegate create_proxy(parent, attrs, sess), to: ProxyResolver, as: :create
  defdelegate delete_proxy(parent, id, sess), to: ProxyResolver, as: :delete
  defdelegate disable_proxy(parent, id, sess), to: ProxyResolver, as: :disable
  defdelegate enable_proxy(parent, id, sess), to: ProxyResolver, as: :enable
  defdelegate get_proxy(parent, id, sess), to: ProxyResolver, as: :get
  defdelegate list_proxies(parent, attrs, sess), to: ProxyResolver, as: :list
  defdelegate purge_proxy(parent, id, sess), to: ProxyResolver, as: :purge
  defdelegate update_proxy(parent, id, sess), to: ProxyResolver, as: :update

  ### Site Functions ###
  defdelegate create_site(parent, attrs, sess), to: SiteResolver, as: :create
  defdelegate delete_site(parent, id, sess), to: SiteResolver, as: :delete
  defdelegate disable_site(parent, id, sess), to: SiteResolver, as: :disable
  defdelegate enable_site(parent, id, sess), to: SiteResolver, as: :enable
  defdelegate get_site(parent, id, sess), to: SiteResolver, as: :get
  defdelegate list_sites(parent, attrs, sess), to: SiteResolver, as: :list
  defdelegate purge_site(parent, id, sess), to: SiteResolver, as: :purge
  defdelegate update_site(parent, id, sess), to: SiteResolver, as: :update
end
