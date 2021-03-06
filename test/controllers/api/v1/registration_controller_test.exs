defmodule Inventory.Api.V1.RegistrationControllerTest do
  use ExUnit.Case
  use Inventory.ConnCase

  alias Inventory.User

  @valid_attrs %{
    email: "test@test.com",
    password: "password",
    "password-confirmation": "password"
  }

  @invalid_attrs %{}

  setup %{conn: conn} do
    conn = conn
           |> put_req_header("accept", "application/vnd.api+json")
           |> put_req_header("content-type", "application/vnd.api+json")

    on_exit fn ->
      Ecto.Adapters.SQL.Sandbox.checkout(Inventory.Repo)

      Inventory.Repo.delete_all(User)
    end

    { :ok, conn: conn }
  end

  test "creates and renders resource with data is valid", %{ conn: conn } do
    conn = post conn, api_v1_registration_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "users",
        "attributes" => @valid_attrs
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(User, email: "test@test.com")
  end

  test "does no create resource and renders errors when data is invalid", %{ conn: conn } do
    assert_error_sent 400, fn ->
      post conn, api_v1_registration_path(conn, :create, %{data: %{type: "users"}, attributes: @invalid_attrs})
    end
  end

end
