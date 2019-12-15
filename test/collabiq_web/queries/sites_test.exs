defmodule CollabiqWeb.Test.Query.Sites do
  use CollabiqWeb.ConnCase, async: true

  @list_query """
  {
    sites {
      name
    }
  }
  """

  @mutation_list_query """
  {
    sites {
      name,
      id
    }
  }
  """

  test "list sites in default order", %{conn: conn} do
    conn = conn |> auth_user()
    response =
      get(conn, "/graphql", query: @list_query)

    assert json_response(response, 200) == %{
      "data" => %{
        "sites" => [
          %{"name" => "ABC"},
          %{"name" => "JKL"},
          %{"name" => "XYZ"}
        ]
      }
    }
  end

  @list_query """
  {
    sites(sort: {field: NAME, order: DESC}) {
      name
    }
  }
  """

  test "list sites in descending name order", %{conn: conn} do
    conn = conn |> auth_user()
    response =
      get(conn, "/graphql", query: @list_query)

    assert json_response(response, 200) == %{
      "data" => %{
        "sites" => [
          %{"name" => "XYZ"},
          %{"name" => "JKL"},
          %{"name" => "ABC"}
        ]
      }
    }
  end

  @create_query """
  mutation CreateSite($input: SiteInput!) {
    createSite(input: $input) {
      site {
        name,
        status
      },
      response {
        code,
        message
      }
    }
  }
  """

  test "create site", %{conn: conn} do
    input = %{
      name: "DFG"
    }

    conn = conn |> auth_user()
    response =
      post(conn, "/graphql", query: @create_query, variables: %{"input" => input})

    assert json_response(response, 200) == %{
      "data" => %{
        "createSite" => %{
          "response" => %{
            "code" => "ok",
            "message" => "site DFG created"
          },
          "site" => %{
            "name" => "DFG",
            "status" => "active"
          }
        }
      }
    }
  end

  @disable_query """
  mutation DisableSite($input: SiteInput!) {
    disableSite(input: $input) {
      site {
        name,
        status
      },
      response {
        code,
        message
      }
    }
  }
  """

  test "disable site", %{conn: conn} do
    conn = conn |> auth_user()

    list =
      get(conn, "/graphql", query: @mutation_list_query)
      |> json_response(200)

    %{"data" => %{"sites" => sites}} = list

    site = Enum.find(sites, %{}, fn %{"name" => name} -> name == "ABC" end)

    input = %{
      id: site["id"]
    }

    response =
      post(conn, "/graphql", query: @disable_query, variables: %{"input" => input})

    assert json_response(response, 200) == %{
      "data" => %{
        "disableSite" => %{
          "response" => %{
            "code" => "ok",
            "message" => "site ABC disabled"
          },
          "site" => %{
            "name" => "ABC",
            "status" => "disabled"
          }
        }
      }
    }
  end

  @delete_query """
  mutation DeleteSite($input: SiteInput!) {
    deleteSite(input: $input) {
      site {
        name,
        status
      },
      response {
        code,
        message
      }
    }
  }
  """

  test "delete site", %{conn: conn} do
    conn = conn |> auth_user()

    list =
      get(conn, "/graphql", query: @mutation_list_query)
      |> json_response(200)

    %{"data" => %{"sites" => sites}} = list

    site = Enum.find(sites, %{}, fn %{"name" => name} -> name == "ABC" end)

    input = %{
      id: site["id"]
    }

    response =
      post(conn, "/graphql", query: @delete_query, variables: %{"input" => input})

    assert json_response(response, 200) == %{
      "data" => %{
        "deleteSite" => %{
          "response" => %{
            "code" => "ok",
            "message" => "site ABC deleted"
          },
          "site" => %{
            "name" => "ABC",
            "status" => "deleted"
          }
        }
      }
    }
  end

  @enable_query """
  mutation EnableSite($input: SiteInput!) {
    enableSite(input: $input) {
      site {
        name,
        status
      },
      response {
        code,
        message
      }
    }
  }
  """

  test "enable site", %{conn: conn} do
    conn = conn |> auth_user()

    list =
      get(conn, "/graphql", query: @mutation_list_query)
      |> json_response(200)

    %{"data" => %{"sites" => sites}} = list

    site = Enum.find(sites, %{}, fn %{"name" => name} -> name == "ABC" end)

    input = %{
      id: site["id"]
    }

    response =
      post(conn, "/graphql", query: @enable_query, variables: %{"input" => input})

    assert json_response(response, 200) == %{
      "data" => %{
        "enableSite" => %{
          "response" => %{
            "code" => "ok",
            "message" => "site ABC enabled"
          },
          "site" => %{
            "name" => "ABC",
            "status" => "active"
          }
        }
      }
    }
  end

  @update_query """
  mutation UpdateSite($input: SiteInput!) {
    updateSite(input: $input) {
      site {
        name
      },
      response {
        code,
        message
      }
    }
  }
  """

  test "update site", %{conn: conn} do
    conn = conn |> auth_user()

    list =
      get(conn, "/graphql", query: @mutation_list_query)
      |> json_response(200)

    %{"data" => %{"sites" => sites}} = list

    site = Enum.find(sites, %{}, fn %{"name" => name} -> name == "ABC" end)

    input = %{
      id: site["id"],
      name: "BCA"
    }

    response =
      post(conn, "/graphql", query: @update_query, variables: %{"input" => input})

    assert json_response(response, 200) == %{
      "data" => %{
        "updateSite" => %{
          "response" => %{
            "code" => "ok",
            "message" => "site BCA updated"
          },
          "site" => %{
            "name" => "BCA"
          }
        }
      }
    }
  end

  defp auth_user(conn) do
    {:ok, session} = Collabiq.Auth.login(%{email: "admin@email.com", password: "password"})
    token = CollabiqWeb.AuthResolver.sign(session)

    put_req_header(conn, "authorization", "Bearer " <> token)
  end
end
