defmodule Inventory.Api.V1.InputControllerTest do
  use Inventory.ConnCase

  alias Inventory.Input
  alias Inventory.Repo
  alias Inventory.Category
  alias Inventory.Product

  @valid_attrs %{disabled: true, label: "some content", meta: %{}, name: "some content", value: "some content", input_type: "text"}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  defp relationships do
    category = Repo.insert!(%Category{name: "My Category"})
    product = Repo.insert!(%Product{name: "My Product"})

    %{
      "category" => %{
        "data" => %{
          "type" => "category",
          "id" => category.id
        }
      },
      "product" => %{
        "data" => %{
          "type" => "product",
          "id" => product.id
        }
      }
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_v1_input_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "lists all entries by category on index", %{conn: conn} do
    post conn, api_v1_input_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "inputs",
        "attributes" => @valid_attrs,
        "relationships" => relationships()
      }
    }

    input =
      Repo.get_by(Input, @valid_attrs)
      |> Repo.preload(:category)

    conn = get conn, api_v1_category_inputs_path(conn, :index, input.category.id)
    response = List.first(json_response(conn, 200)["data"])
    assert response["attributes"]["name"] == "some content"
  end

  test "shows chosen resource", %{conn: conn} do
    input = Repo.insert! %Input{}
    conn = get conn, api_v1_input_path(conn, :show, input)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{input.id}"
    assert data["type"] == "input"
    assert data["attributes"]["name"] == input.name
    assert data["attributes"]["label"] == input.label
    assert data["attributes"]["value"] == input.value
    assert data["attributes"]["disabled"] == input.disabled
    assert data["attributes"]["meta"] == input.meta
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, api_v1_input_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, api_v1_input_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "inputs",
        "attributes" => @valid_attrs,
        "relationships" => relationships()
      }
    }

    input =
      Repo.get_by(Input, @valid_attrs)
      |> Repo.preload(:category)

    assert json_response(conn, 201)["data"]["id"]
    assert input.category.name == "My Category"
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, api_v1_input_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "inputs",
        "attributes" => @invalid_attrs,
        "relationships" => relationships()
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    input = Repo.insert! %Input{}
    conn = put conn, api_v1_input_path(conn, :update, input), %{
      "meta" => %{},
      "data" => %{
        "type" => "inputs",
        "id" => input.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships()
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Input, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    input = Repo.insert! %Input{}
    conn = put conn, api_v1_input_path(conn, :update, input), %{
      "meta" => %{},
      "data" => %{
        "type" => "inputs",
        "id" => input.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships()
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    input = Repo.insert! %Input{}
    conn = delete conn, api_v1_input_path(conn, :delete, input)
    assert response(conn, 204)
    refute Repo.get(Input, input.id)
  end

end
