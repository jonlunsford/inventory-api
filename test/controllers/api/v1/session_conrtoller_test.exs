defmodule Inventory.Api.V1.SessionControllerTest do
  use ExUnit.Case
  use Inventory.ConnCase

  alias Inventory.User
  alias Inventory.Repo

  setup %{conn: conn} do
    User.changeset(%User{}, %{email: "test@example.com", password: "password", password_confirmation: "password"})
    |> Repo.insert!

    conn = conn
           |> put_req_header("accept", "application/vnd.api+json")
           |> put_req_header("content-type", "application/vnd.api+json")

    on_exit fn ->
      Ecto.Adapters.SQL.Sandbox.checkout(Repo)

      Inventory.Repo.delete_all(User)
    end

    { :ok, conn: conn }
  end

  test "POST /api/v1/token", %{conn: conn} do
    conn = post conn, api_v1_login_path(conn, :create), %{grant_type: "password", username: "test@example.com", password: "password"}
    assert json_response(conn, 200)["access_token"]
  end

  test "POST /api/v1/token with invalid username", %{conn: conn} do
    conn = post conn, api_v1_login_path(conn, :create), %{grant_type: "password", username: "test@example.com", password: "pass"}
    assert hd(json_response(conn, 401)["errors"])["title"] == "Unauthorized"
  end
end
