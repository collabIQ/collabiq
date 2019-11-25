defmodule Collabiq.Query do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Collabiq.UUID

  def filter(query, %{filter: filter}, schema) do
    filter
    |> Enum.reduce(query, fn
      {:email, email}, query when is_nil(email) or email == "" ->
        query

      {:email, email}, query when schema in [:user] ->
        from(q in query,
          where: ilike(q.email, ^"%#{String.downcase(email)}%")
        )

      {:name, name}, query when is_nil(name) or name == "" ->
        query

      {:name, name}, query ->
        from(q in query,
          where: ilike(q.name, ^"%#{String.downcase(name)}%")
        )

      {:status, [_ | _] = status}, query ->
        from(q in query,
          where: q.status in ^status
        )

      {:status, _}, query ->
        query

      {:types, [_ | _] = type}, query when schema in [:role, :user] ->
        from(q in query,
          where: q.type in ^type
        )

      {:types, _}, query ->
        query

      {:workspaces, [_ | _] = workspaces}, query when schema in [:user] ->
        workspaces =
          workspaces
          |> Enum.map(fn x ->
            case UUID.validate_id(x) do
              {:ok, id} ->
                id

              _ ->
                []
            end
          end)
          |> List.flatten()

        from([q, j] in query,
          where: j.id in ^workspaces
        )

      {:workspaces, [_ | _] = work}, query ->
        from(q in query,
          where: q.workspace_id in ^work
        )

      {:workspaces, _}, query ->
        query

      {_, _}, query ->
        query
    end)
  end

  def filter(query, _args, _schema), do: query

  def site_scope(query, %{scopes: scopes, sites: sites}, schema) do
    sites = UUID.base_to_string(sites)

    id =
      case schema do
        _ when schema in [:site] ->
          :id

        _ ->
          :site_id
      end

    case scopes do
      %{site: "all"} ->
        query

      _ when schema in [:user] ->
        from([q, w] in query,
          where: field(w, ^id) in ^sites
        )

      _ ->
        from(q in query,
          where: field(q, ^id) in ^sites
        )
    end
  end

  def sort(query, %{sort: %{field: field, order: order}}, schema) when order in ["asc", "desc", :asc, :desc] do
    IO.puts(order)
    case field do
      :created_at when schema in [:article, :department, :location, :site, :team, :workspace] ->
        query
        |> order_by([q], {^order, q.created_at})

      "email" when schema in [:user] ->
        case order do
          "desc" ->
            from(q in query,
              order_by: fragment("lower(email) DESC")
            )

          _ ->
            from(q in query,
              order_by: fragment("lower(email) ASC")
            )
        end

      :name when schema in [:article, :department, :location, :role, :site, :team, :workspace] ->
        query
        |> order_by([q], {^order, q.name})

      :status when schema in [:department, :location, :role, :site, :team, :workspace] ->
        query
        |> order_by([q], {^order, q.status})

      "type" when schema in [:group, :role] ->
        case order do
          "desc" ->
            from(q in query,
              order_by: [desc: q.type],
              order_by: fragment("lower(name) ASC")
            )

          _ ->
            from(q in query,
              order_by: [asc: q.type],
              order_by: fragment("lower(name) ASC")
            )
        end

      :updated_at when schema in [:article, :department, :location, :site, :team, :workspace] ->
        query
        |> order_by([q], {^order, q.updated_at})

      :user_count when schema in [:department, :location, :site, :team, :workspace] ->
        query
        |> order_by([q, u], {^order, count(u.id)})

      _ ->
        from(q in query,
          #order_by: fragment("lower(?) ASC", q.name)
          order_by: [asc: :name]
        )
    end
  end

  def sort(query, _args, schema) when schema in [:article] do
    from(q in query,
      order_by: [asc: q.created_at]
    )
  end

  def sort(query, _args, schema) when schema in [:department, :group, :role, :team, :user, :workspace] do
    from(q in query,
      #order_by: fragment("lower(name) ASC")
      order_by: [asc: :name]
    )
  end

  def sort(query, _args, _schema), do: query
end
