defmodule CollabiqWeb.SiteType do
  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern
  #import Absinthe.Resolution.Helpers
  alias CollabiqWeb.Resolver

  object :site_query do
    field :site, :site do
      arg(:id, non_null(:id))
      middleware(CollabiqWeb.AuthMiddleware)
      resolve(&Resolver.get_site/3)
    end

    field :sites, list_of(:site) do
      arg(:filter, :filter_input)
      arg(:sort, :sort_input)
      middleware(CollabiqWeb.AuthMiddleware)
      resolve(&Resolver.list_sites/3)
    end
  end

  object :site_mutation do
    field :create_site, :site_input_result do
      arg(:input, non_null(:site_input))
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.create_site/3)
    end

    field :delete_site, :site_input_result do
      arg(:input, non_null(:site_input))
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.delete_site/3)
    end

    field :disable_site, :site_input_result do
      arg(:input, non_null(:site_input))
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.disable_site/3)
    end

    field :enable_site, :site_input_result do
      arg(:input, non_null(:site_input))
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.enable_site/3)
    end

    field :purge_site, :site_input_result do
      arg(:input, non_null(:site_input))
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.purge_site/3)
    end

    field :update_site, :site_input_result do
      arg(:input, non_null(:site_input))
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.update_site/3)
    end
  end

  ###############
  ### Objects ###
  ###############
  object :site do
    field(:id, :id)
    field(:created_at, :datetime)
    field(:deleted_at, :datetime)
    field(:description, :string)
    field(:name, :string)
    field(:status, :string)
    field(:updated_at, :datetime)
    field(:user_count, :integer)
    # field :users, list_of(:user) do
    #   arg(:filter, :filter_input)
    #   arg(:sort, :sort_input)
    #   resolve fn workspace, attrs, %{context: %{loader: loader}} ->
    #     workspace = Repo.reverse_id_in_struct(workspace)

    #     loader
    #     |> Dataloader.load(Directory, {:users, attrs}, workspace)
    #     |> on_load(fn loader ->
    #       users =
    #         loader
    #         |> Dataloader.get(Directory, {:users, attrs}, workspace)
    #         |> Repo.replace_ids_in_list()
    #       {:ok, users}
    #     end)
    #   end
    # end
  end

  #####################
  ### Input Objects ###
  #####################
  input_object :site_input do
    field(:id, :id)
    field(:description, :string)
    field(:name, :string)
  end

  #####################
  ### Input Results ###
  #####################
  object :site_input_result do
    field(:site, :site)
    field(:response, :input_response)
  end
end
