defmodule Inventory.Api.V1.RoomControllerTest do
  use Inventory.ConnCase

  alias Inventory.Room
  alias Inventory.User

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    user = User.changeset(%User{}, %{email: "test@example.com", password: "password", password_confirmation: "password"})
           |> Repo.insert!

    {:ok, jwt, full_claims} = Guardian.encode_and_sign(user)

    {:ok, %{user: user, jwt: jwt, claims: full_claims}}
  end

  test "lists all entries on index", %{jwt: jwt} do
    conn = build_conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get(api_v1_room_path(build_conn, :index))

    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{jwt: jwt} do
    room = Repo.insert! %Room{}

    conn = build_conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> get(api_v1_room_path(build_conn, :show, room))

    assert json_response(conn, 200)["data"] == %{"id" => room.id,
      "name" => room.name,
      "owner_id" => room.owner_id}
  end

  test "renders page not found when id is nonexistent", %{jwt: jwt} do
    assert_error_sent 404, fn ->
      build_conn
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> get(api_v1_room_path(build_conn, :show, -1))
    end
  end

  test "creates and renders resource when data is valid", %{jwt: jwt} do
    params = %{"data" => %{"type" => "rooms", "attributes" => @valid_attrs, relationships:  ""}}

    conn = build_conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> post(api_v1_room_path(build_conn, :create), params)

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Room, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{jwt: jwt} do
    params = %{"data" => %{"type" => "rooms", "attributes" => @invalid_attrs, relationships:  ""}}

    conn = build_conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> post(api_v1_room_path(build_conn, :create), params)

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{jwt: jwt, user: user} do
    room = Repo.insert! %Room{owner_id: user.id}
    params = %{id: room.id, data: %{id: room.id, type: "rooms", attributes: %{name: "My Room"}}}

    conn = build_conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put(api_v1_room_path(build_conn, :update, room), params)

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get(Room, room.id)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{jwt: jwt, user: user} do
    room = Repo.insert! %Room{owner_id: user.id}
    params = %{id: room.id, data: %{id: room.id, type: "rooms", attributes: %{}}}

    conn = build_conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> put(api_v1_room_path(build_conn, :update, room), params)

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{jwt: jwt, user: user} do
    room = Repo.insert! %Room{owner_id: user.id}

    conn = build_conn
      |> put_req_header("authorization", "Bearer #{jwt}")
      |> delete(api_v1_room_path(build_conn, :delete, room))

    assert response(conn, 204)
    refute Repo.get(Room, room.id)
  end
end
