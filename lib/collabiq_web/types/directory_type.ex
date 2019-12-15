defmodule CollabiqWeb.DirectoryType do
  use Absinthe.Schema.Notation
  #import Absinthe.Resolution.Helpers
  alias CollabiqWeb.Resolver

  object :directory_query do
    field :directory, :directory do
      arg(:id, non_null(:id))
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.get_directory/3)
    end

    field :directories, list_of(:directory) do
      arg(:filter, :filter_input)
      arg(:sort, :sort_input)
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.list_directories/3)
    end
  end

  object :directory_mutation do
    field :create_directory, :directory_input_result do
      arg(:input, non_null(:directory_input))
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.create_directory/3)
    end

    field :delete_directory, :directory_input_result do
      arg(:input, non_null(:directory_input))
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.delete_directory/3)
    end

    field :disable_directory, :directory_input_result do
      arg(:input, non_null(:directory_input))
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.disable_directory/3)
    end

    field :enable_directory, :directory_input_result do
      arg(:input, non_null(:directory_input))
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.enable_directory/3)
    end

    field :purge_directory, :directory_input_result do
      arg(:input, non_null(:directory_input))
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.purge_directory/3)
    end

    field :update_directory, :directory_input_result do
      arg(:input, non_null(:directory_input))
      #middleware(CollabiqWeb.Middleware.Auth)
      resolve(&Resolver.update_directory/3)
    end
  end

  ###############
  ### Objects ###
  ###############
  object :directory do
    field(:id, :id)
    field(:created_at, :datetime)
    field(:deleted_at, :datetime)
    field(:description, :string)
    field(:pw, :string)
    field(:name, :string)
    field(:server, :string)
    field(:site_id, :id)
    field(:status, :string)
    field(:un, :string)
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
  input_object :directory_input do
    field(:id, :id)
    field(:description, :string)
    field(:name, :string)
    field(:pw, :string)
    field(:server, :string)
    field(:site_id, :id)
    field(:un, :string)
  end

  #####################
  ### Input Results ###
  #####################
  object :directory_input_result do
    field(:directory, :directory)
    field(:response, :input_response)
  end
end
