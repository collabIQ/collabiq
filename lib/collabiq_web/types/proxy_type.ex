defmodule CollabiqWeb.ProxyType do
  use Absinthe.Schema.Notation
  #import Absinthe.Resolution.Helpers
  alias CollabiqWeb.Resolver

  object :proxy_query do
    field :proxy, :proxy do
      arg(:id, non_null(:id))
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.get_proxy/3)
    end

    field :proxies, list_of(:proxy) do
      arg(:filter, :filter_input)
      arg(:sort, :sort_input)
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.list_proxies/3)
    end
  end

  object :proxy_mutation do
    field :create_proxy, :proxy_input_result do
      arg(:input, non_null(:proxy_input))
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.create_proxy/3)
    end

    field :delete_proxy, :proxy_input_result do
      arg(:input, non_null(:proxy_input))
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.delete_proxy/3)
    end

    field :disable_proxy, :proxy_input_result do
      arg(:input, non_null(:proxy_input))
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.disable_proxy/3)
    end

    field :enable_proxy, :proxy_input_result do
      arg(:input, non_null(:proxy_input))
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.enable_proxy/3)
    end

    field :purge_proxy, :proxy_input_result do
      arg(:input, non_null(:proxy_input))
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.purge_proxy/3)
    end

    field :update_proxy, :proxy_input_result do
      arg(:input, non_null(:proxy_input))
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.update_proxy/3)
    end
  end

  ###############
  ### Objects ###
  ###############
  object :proxy do
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
  input_object :proxy_input do
    field(:id, :id)
    field(:description, :string)
    field(:name, :string)
  end

  #####################
  ### Input Results ###
  #####################
  object :proxy_input_result do
    field(:proxy, :proxy)
    field(:response, :input_response)
  end
end
