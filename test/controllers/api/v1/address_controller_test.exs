defmodule Inventory.Api.V1.AddressControllerTest do
  use Inventory.ConnCase

  alias Inventory.Address
  alias Inventory.Repo

  @valid_attrs %{city: "some content", country: "some content", description: "some content", lat: "120.5", line1: "some content", line2: "some content", long: "120.5", phone: "some content", state: "some content", zip: 42}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  defp relationships do
    company = Repo.insert!(%Inventory.Company{})

    %{
      "company" => %{
        "data" => %{
          "type" => "company",
          "id" => company.id
        }
      }
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_v1_address_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "lists entry by company id on index", %{conn: conn} do
    post conn, api_v1_address_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "addresses",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    address =
      Repo.get_by(Address, @valid_attrs)
      |> Repo.preload(:company)

    conn = get conn, api_v1_company_address_path(conn, :index, address.company.id)
    response = List.first(json_response(conn, 200)["data"])
    assert response["relationships"]["company"]["data"]
  end

  test "shows chosen resource", %{conn: conn} do
    address = Repo.insert! %Address{}
    conn = get conn, api_v1_address_path(conn, :show, address)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{address.id}"
    assert data["type"] == "address"
    assert data["attributes"]["city"] == address.city
    assert data["attributes"]["state"] == address.state
    assert data["attributes"]["country"] == address.country
    assert data["attributes"]["zip"] == address.zip
    assert data["attributes"]["lat"] == address.lat
    assert data["attributes"]["long"] == address.long
    assert data["attributes"]["line1"] == address.line1
    assert data["attributes"]["line2"] == address.line2
    assert data["attributes"]["phone"] == address.phone
    assert data["attributes"]["description"] == address.description
    assert data["attributes"]["company_id"] == address.company_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, api_v1_address_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, api_v1_address_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "addresses",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Address, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, api_v1_address_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "addresses",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    address = Repo.insert! %Address{}
    conn = put conn, api_v1_address_path(conn, :update, address), %{
      "meta" => %{},
      "data" => %{
        "type" => "addresses",
        "id" => address.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Address, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    address = Repo.insert! %Address{}
    conn = put conn, api_v1_address_path(conn, :update, address), %{
      "meta" => %{},
      "data" => %{
        "type" => "addresses",
        "id" => address.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    address = Repo.insert! %Address{}
    conn = delete conn, api_v1_address_path(conn, :delete, address)
    assert response(conn, 204)
    refute Repo.get(Address, address.id)
  end

end
