defmodule Inventory.Api.V1.UserControllerTest do
  use ExUnit.Case
  use Inventory.ConnCase

  alias Inventory.User
  alias Inventory.Repo

  setup %{conn: conn} do
    user = Repo.insert! %User{}

    {:ok, jwt, _} = Guardian.encode_and_sign(user, :token)

    conn = conn
           |> put_req_header("content-type", "application/vnd.api+json")
           |> put_req_header("authorization", "Bearer #{jwt}")

    on_exit fn ->
      Ecto.Adapters.SQL.Sandbox.checkout(Repo)
      Inventory.Repo.delete_all(User)
    end

    {:ok, %{conn: conn, user: user}}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_v1_user_path(conn, :index)
    assert json_response(conn, 200)
  end

end
