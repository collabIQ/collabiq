defmodule CollabiqWeb.Test.Query.Directories do
  use CollabiqWeb.ConnCase, async: true

  @list_query """
  {
    directories {
      name
    }
  }
  """

  @mutation_list_query """
  {
    directories {
      name,
      id
    }
  }
  """

  test "list directories in default order", %{conn: conn} do
    conn = conn |> auth_user()
    response =
      get(conn, "/graphql", query: @list_query)

    assert json_response(response, 200) == %{
      "data" => %{
        "directories" => [
          %{"name" => "ABC AD"},
          %{"name" => "JKL AD"},
          %{"name" => "XYZ AD"}
        ]
      }
    }
  end

  @list_query """
  {
    directories(sort: {field: NAME, order: DESC}) {
      name
    }
  }
  """

  test "list directories in descending name order", %{conn: conn} do
    conn = conn |> auth_user()
    response =
      get(conn, "/graphql", query: @list_query)

    assert json_response(response, 200) == %{
      "data" => %{
        "directories" => [
          %{"name" => "XYZ AD"},
          %{"name" => "JKL AD"},
          %{"name" => "ABC AD"}
        ]
      }
    }
  end

  @sites_query """
  {
    sites {
      name,
      id
    }
  }
  """

  @create_query """
  mutation CreateDirectory($input: DirectoryInput!) {
    createDirectory(input: $input) {
      directory {
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

  test "create directory", %{conn: conn} do
    conn = conn |> auth_user()
    sites_list =
      get(conn, "/graphql", query: @sites_query)
      |> json_response(200)

    %{"data" => %{"sites" => sites}} = sites_list

    site = Enum.find(sites, %{}, fn %{"name" => name} -> name == "ABC" end)

    input = %{
      name: "DFG AD",
      site_id: site["id"],
      server: "127.0.0.1"
    }

    response =
      post(conn, "/graphql", query: @create_query, variables: %{"input" => input})

    assert json_response(response, 200) == %{
      "data" => %{
        "createDirectory" => %{
          "response" => %{
            "code" => "ok",
            "message" => "directory DFG AD created"
          },
          "directory" => %{
            "name" => "DFG AD",
            "status" => "active"
          }
        }
      }
    }
  end

  @disable_query """
  mutation DisableDirectory($input: DirectoryInput!) {
    disableDirectory(input: $input) {
      directory {
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

  test "disable directory", %{conn: conn} do
    conn = conn |> auth_user()

    list =
      get(conn, "/graphql", query: @mutation_list_query)
      |> json_response(200)

    %{"data" => %{"directories" => directories}} = list

    directory = Enum.find(directories, %{}, fn %{"name" => name} -> name == "ABC AD" end)

    input = %{
      id: directory["id"]
    }

    response =
      post(conn, "/graphql", query: @disable_query, variables: %{"input" => input})

    assert json_response(response, 200) == %{
      "data" => %{
        "disableDirectory" => %{
          "response" => %{
            "code" => "ok",
            "message" => "directory ABC AD disabled"
          },
          "directory" => %{
            "name" => "ABC AD",
            "status" => "disabled"
          }
        }
      }
    }
  end

  @delete_query """
  mutation DeleteDirectory($input: DirectoryInput!) {
    deleteDirectory(input: $input) {
      directory {
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

  test "delete directory", %{conn: conn} do
    conn = conn |> auth_user()

    list =
      get(conn, "/graphql", query: @mutation_list_query)
      |> json_response(200)

    %{"data" => %{"directories" => directories}} = list

    directory = Enum.find(directories, %{}, fn %{"name" => name} -> name == "ABC AD" end)

    input = %{
      id: directory["id"]
    }

    response =
      post(conn, "/graphql", query: @delete_query, variables: %{"input" => input})

    assert json_response(response, 200) == %{
      "data" => %{
        "deleteDirectory" => %{
          "response" => %{
            "code" => "ok",
            "message" => "directory ABC AD deleted"
          },
          "directory" => %{
            "name" => "ABC AD",
            "status" => "deleted"
          }
        }
      }
    }
  end

  @enable_query """
  mutation EnableDirectory($input: DirectoryInput!) {
    enableDirectory(input: $input) {
      directory {
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

  test "enable directory", %{conn: conn} do
    conn = conn |> auth_user()

    list =
      get(conn, "/graphql", query: @mutation_list_query)
      |> json_response(200)

    %{"data" => %{"directories" => directories}} = list

    directory = Enum.find(directories, %{}, fn %{"name" => name} -> name == "ABC AD" end)

    input = %{
      id: directory["id"]
    }

    response =
      post(conn, "/graphql", query: @enable_query, variables: %{"input" => input})

    assert json_response(response, 200) == %{
      "data" => %{
        "enableDirectory" => %{
          "response" => %{
            "code" => "ok",
            "message" => "directory ABC AD enabled"
          },
          "directory" => %{
            "name" => "ABC AD",
            "status" => "active"
          }
        }
      }
    }
  end

  @update_query """
  mutation UpdateDirectory($input: DirectoryInput!) {
    updateDirectory(input: $input) {
      directory {
        name
      },
      response {
        code,
        message
      }
    }
  }
  """

  test "update directory", %{conn: conn} do
    conn = conn |> auth_user()

    list =
      get(conn, "/graphql", query: @mutation_list_query)
      |> json_response(200)

    %{"data" => %{"directories" => directories}} = list

    directory = Enum.find(directories, %{}, fn %{"name" => name} -> name == "ABC AD" end)

    input = %{
      id: directory["id"],
      name: "BCA AD"
    }

    response =
      post(conn, "/graphql", query: @update_query, variables: %{"input" => input})

    assert json_response(response, 200) == %{
      "data" => %{
        "updateDirectory" => %{
          "response" => %{
            "code" => "ok",
            "message" => "directory BCA AD updated"
          },
          "directory" => %{
            "name" => "BCA AD"
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
