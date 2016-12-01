defmodule Inventory.Api.V1.ProductControllerTest do
  use Inventory.ConnCase

  alias Inventory.Product
  alias Inventory.Repo
  alias Inventory.Category
  alias Inventory.Input

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  defp relationships do
    category_a = Repo.insert!(%Category{name: "My Category"})
    category_b = Repo.insert!(%Category{name: "My Second Category"})

    %{
      "categories" => %{
        "data" => [
            %{
            "type" => "categories",
            "id" => category_a.id
          }, %{
            "type" => "categories",
            "id" => category_b.id
          }
        ]
      }
    }
  end

  defp category_relationship do
    category = Repo.insert!(%Category{name: "My Third Category"})

    %{
      "categories" => %{
        "data" => [
            %{
            "type" => "categories",
            "id" => category.id
          }
        ]
      }
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_v1_product_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end


  test "lists all entries by category on index", %{conn: conn} do
    post conn, api_v1_product_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "products",
        "attributes" => %{name: "one"},
        "relationships" => category_relationship
      }
    }

    product =
      Repo.get_by(Product, %{name: "one"})
      |> Repo.preload(:categories)

    conn = get conn, api_v1_category_products_path(conn, :index, List.first(product.categories).id)
    response = List.first(json_response(conn, 200)["data"])
    assert response["attributes"]["name"] == "one"
  end

  test "shows chosen resource", %{conn: conn} do
    product = Repo.insert! %Product{}
    conn = get conn, api_v1_product_path(conn, :show, product)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{product.id}"
    assert data["type"] == "product"
    assert data["attributes"]["name"] == product.name
  end

  test "copies category inputs to itself", %{conn: conn} do
    category = Repo.insert! %Category{name: "Parent Category"}
    Repo.insert %Input{name: "copied_input", label: "Copied Input", value: "Copied Value", input_type: "text", category_id: category.id}

    conn = get conn, api_v1_product_path(conn, :new, %{category_id: category.id})
    response = json_response(conn, 201)["data"]
    assert response["attributes"]["name"] == "New Parent Category Inventory"

    product =
      Repo.get(Product, response["id"])
      |> Repo.preload([:inputs])

    category =
      Repo.get(Category, category.id)
      |> Repo.preload(:inputs)

    assert List.first(product.inputs).product_id == product.id
    assert List.first(product.inputs).category_id == nil
    assert List.first(category.inputs).product_id == nil
    assert List.first(category.inputs).category_id == category.id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, api_v1_product_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, api_v1_product_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "products",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    product =
      Repo.get_by(Product, @valid_attrs)
      |> Repo.preload([:inputs, :categories])

    assert json_response(conn, 201)["data"]["id"]
    assert product.name == "some content"
    assert List.first(product.categories).name == "My Category"
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, api_v1_product_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "products",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    product = Repo.insert! %Product{}
    conn = put conn, api_v1_product_path(conn, :update, product), %{
      "meta" => %{},
      "data" => %{
        "type" => "products",
        "id" => product.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Product, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    product = Repo.insert! %Product{}
    conn = put conn, api_v1_product_path(conn, :update, product), %{
      "meta" => %{},
      "data" => %{
        "type" => "products",
        "id" => product.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    product = Repo.insert! %Product{}
    conn = delete conn, api_v1_product_path(conn, :delete, product)
    assert response(conn, 204)
    refute Repo.get(Product, product.id)
  end

end
