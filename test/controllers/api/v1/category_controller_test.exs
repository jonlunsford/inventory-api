defmodule Inventory.Api.V1.CategoryControllerTest do
  use Inventory.ConnCase

  alias Inventory.Category
  alias Inventory.Repo
  alias Inventory.User

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    user = Repo.insert! %User{}

    {:ok, jwt, _} = Guardian.encode_and_sign(user, :token)

    conn = conn
           |> put_req_header("accept", "application/vnd.api+json")
           |> put_req_header("content-type", "application/vnd.api+json")
           |> put_req_header("authorization", "Bearer #{jwt}")

    on_exit fn ->
      Ecto.Adapters.SQL.Sandbox.checkout(Repo)
      Inventory.Repo.delete_all(User)
    end

    {:ok, %{conn: conn, user: user}}
  end

  defp relationships do
    company = Repo.insert!(%Inventory.Company{})

    %{
      "company" => %{
        "data" => %{
          "type" => "company",
          "id" => company.id
        }
      },
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_v1_category_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "lists all entries by company on index", %{conn: conn, user: user} do
    company_id = relationships["company"]["data"]["id"]

    Repo.insert!(%Category{name: "My Cat", company_id: company_id})

    conn = get conn, "/api/v1/user/#{user.id}/companies/#{company_id}/categories"
    response = List.first(json_response(conn, 200)["data"])
    assert response["relationships"]["company"]["data"]["id"] == Integer.to_string(company_id)
  end

  test "shows chosen resource", %{conn: conn} do
    category = Repo.insert! %Category{}
    conn = get conn, api_v1_category_path(conn, :show, category)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{category.id}"
    assert data["type"] == "category"
    assert data["attributes"]["name"] == category.name
    assert data["attributes"]["company_id"] == category.company_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, api_v1_category_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, api_v1_category_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "categories",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    response = json_response(conn, 201)

    assert response["data"]["relationships"]["company"]["data"]
    assert response["data"]["id"]
    assert Repo.get_by(Category, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, api_v1_category_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "categories",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    category = Repo.insert! %Category{}
    conn = put conn, api_v1_category_path(conn, :update, category), %{
      "meta" => %{},
      "data" => %{
        "type" => "categories",
        "id" => category.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Category, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    category = Repo.insert! %Category{}
    conn = put conn, api_v1_category_path(conn, :update, category), %{
      "meta" => %{},
      "data" => %{
        "type" => "categories",
        "id" => category.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    category = Repo.insert! %Category{}
    conn = delete conn, api_v1_category_path(conn, :delete, category)
    assert response(conn, 204)
    refute Repo.get(Category, category.id)
  end

end
