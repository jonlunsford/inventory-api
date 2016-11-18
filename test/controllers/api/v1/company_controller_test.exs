defmodule Inventory.Api.V1.CompanyControllerTest do
  use Inventory.ConnCase

  alias Inventory.Company
  alias Inventory.Repo

  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  defp relationships do
    %{}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_v1_company_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    company = Repo.insert! %Company{}
    conn = get conn, api_v1_company_path(conn, :show, company)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{company.id}"
    assert data["type"] == "company"
    assert data["attributes"]["title"] == company.title
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, api_v1_company_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, api_v1_company_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "company",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Company, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, api_v1_company_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "company",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    company = Repo.insert! %Company{}
    conn = put conn, api_v1_company_path(conn, :update, company), %{
      "meta" => %{},
      "data" => %{
        "type" => "company",
        "id" => company.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Company, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    company = Repo.insert! %Company{}
    conn = put conn, api_v1_company_path(conn, :update, company), %{
      "meta" => %{},
      "data" => %{
        "type" => "company",
        "id" => company.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    company = Repo.insert! %Company{}
    conn = delete conn, api_v1_company_path(conn, :delete, company)
    assert response(conn, 204)
    refute Repo.get(Company, company.id)
  end

end
