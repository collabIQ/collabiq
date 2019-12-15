defmodule CollabiqWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern
  alias Collabiq.{Data}

  def context(context) do
    default_params = Map.take(context, [:session])
    source = Data.dataloader(default_params)
    dataloader =
      Dataloader.new()
      |> Dataloader.add_source(Department, source)
      |> Dataloader.add_source(Folder, source)
      |> Dataloader.add_source(Group, source)
      |> Dataloader.add_source(User, source)
      |> Dataloader.add_source(Workspace, source)

    Map.put(context, :loader, dataloader)
  end

  def plugins() do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

  def middleware(middleware, _field, _object) do
    middleware
  end

  import_types(Absinthe.Type.Custom)
  import_types(CollabiqWeb.AuthType)
  import_types(CollabiqWeb.DirectoryType)
  import_types(CollabiqWeb.ProxyType)
  import_types(CollabiqWeb.SiteType)

  node interface do
    resolve_type fn
      _, _ ->
        nil
    end
  end
  query do
    node field do
      resolve fn
        %{id: id}, _ ->
          {:ok, id}
      end
    end
    import_fields(:directory_query)
    import_fields(:proxy_query)
    import_fields(:site_query)
  end

  mutation do
    import_fields(:auth_mutation)
    import_fields(:directory_mutation)
    import_fields(:proxy_query)
    import_fields(:site_mutation)
  end

  object :input_error do
    field(:message, non_null(:string))
  end

  object :input_response do
    field(:message, :string)
    field(:code, :string)
  end

  ###############
  ### Objects ###
  ###############
  object :users_count do
    field(:total, :integer)
  end

  #####################
  ### Input Objects ###
  #####################
  input_object :filter_input do
    field(:name, :string)
    field(:permissions, list_of(:string))
    field(:status, list_of(:string))
    field(:types, list_of(:string))
    field(:sites, list_of(:id))
  end

  input_object :sort_input do
    field(:field, :sort_input_field)
    field(:order, :sort_input_order)
  end

#############
### Enums ###
#############
  enum :sort_input_field do
    value(:created_at)
    value(:name)
    value(:status)
    value(:type)
    value(:updated_at)
    value(:user_count)
  end

  enum :sort_input_order do
    value(:asc)
    value(:desc)
  end
end
