defmodule Inventory.Api.V1.RoomControllerTest do
  use Inventory.ConnCase

  alias Inventory.Room
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
    owner = Repo.insert!(%Inventory.User{})
    message = Repo.insert!(%Inventory.Message{owner_id: owner.id})

    %{
      "message" => %{
        "data" => %{
          "content" => "some content",
          "id" => message.id
        }
      }
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_v1_room_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "lists all entries by user", %{conn: conn, user: user} do
    room_a = Repo.insert! %Room{owner_id: user.id}
    room_b = Repo.insert! %Room{owner_id: user.id}
    conn = get conn, api_v1_room_path(conn, :index), %{user_id: user.id}

    assert List.first(json_response(conn, 200)["data"])["id"] == Integer.to_string(room_a.id)
    assert List.last(json_response(conn, 200)["data"])["id"] == Integer.to_string(room_b.id)
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    room = Repo.insert! %Room{owner_id: user.id, name: "My Room"}

    Ecto.build_assoc(room, :messages, content: "My Content", owner_id: user.id)
    |> Repo.insert

    conn = get conn, api_v1_room_path(conn, :show, room)

    response = json_response(conn, 200)

    assert response["data"]["id"] == Integer.to_string(room.id)
    assert List.first(response["included"])["attributes"]["content"] == "My Content"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, api_v1_room_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, api_v1_room_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "rooms",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Room, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    params = %{"data" => %{"type" => "rooms", "attributes" => @invalid_attrs, relationships:  ""}}
    conn = post conn, api_v1_room_path(conn, :create), params

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, user: user} do
    room = Repo.insert! %Room{owner_id: user.id}
    params = %{id: room.id, data: %{id: room.id, type: "rooms", attributes: %{name: "My Room"}}}
    conn = put conn, api_v1_room_path(conn, :update, room), params

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get(Room, room.id)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
    room = Repo.insert! %Room{owner_id: user.id}
    params = %{id: room.id, data: %{id: room.id, type: "rooms", attributes: %{}}}
    conn = put conn, api_v1_room_path(conn, :update, room), params

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, user: user} do
    room = Repo.insert! %Room{owner_id: user.id}
    conn = delete conn, api_v1_room_path(conn, :delete, room)

    assert response(conn, 204)
    refute Repo.get(Room, room.id)
  end
end
