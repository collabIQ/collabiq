defmodule Collabiq do
  @moduledoc false
  alias Collabiq.{Directory, Proxy, Site}

  ### Directory Functions ###
  defdelegate create_directory(attrs, sess, opts \\ []), to: Directory, as: :create
  defdelegate delete_directory(id, sess, opts \\ []), to: Directory, as: :delete
  defdelegate disable_directory(id, sess, opts \\ []), to: Directory, as: :disable
  defdelegate enable_directory(id, sess, opts \\ []), to: Directory, as: :enable
  defdelegate get_directory(id, sess, opts \\ []), to: Directory, as: :get
  defdelegate list_directories(attrs, sess, opts \\ []), to: Directory, as: :list
  defdelegate purge_directory(id, sess, opts \\ []), to: Directory, as: :purge
  defdelegate update_directory(id, sess, opts \\ []), to: Directory, as: :update

  ### Proxy Functions ###
  defdelegate create_proxy(attrs, sess, opts \\ []), to: Proxy, as: :create
  defdelegate delete_proxy(id, sess, opts \\ []), to: Proxy, as: :delete
  defdelegate disable_proxy(id, sess, opts \\ []), to: Proxy, as: :disable
  defdelegate enable_proxy(id, sess, opts \\ []), to: Proxy, as: :enable
  defdelegate get_proxy(id, sess, opts \\ []), to: Proxy, as: :get
  defdelegate list_proxies(attrs, sess, opts \\ []), to: Proxy, as: :list
  defdelegate purge_proxy(id, sess, opts \\ []), to: Proxy, as: :purge
  defdelegate update_proxy(id, sess, opts \\ []), to: Proxy, as: :update

  ### Site Functions ###
  defdelegate create_site(attrs, sess, opts \\ []), to: Site, as: :create
  defdelegate delete_site(id, sess, opts \\ []), to: Site, as: :delete
  defdelegate disable_site(id, sess, opts \\ []), to: Site, as: :disable
  defdelegate enable_site(id, sess, opts \\ []), to: Site, as: :enable
  defdelegate get_site(id, sess, opts \\ []), to: Site, as: :get
  defdelegate list_sites(attrs, sess, opts \\ []), to: Site, as: :list
  defdelegate purge_site(id, sess, opts \\ []), to: Site, as: :purge
  defdelegate update_site(id, sess, opts \\ []), to: Site, as: :update
end
