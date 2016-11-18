defmodule Inventory.Api.V1.MessageControllerTest do
  use Inventory.ConnCase

  alias Inventory.Message
  alias Inventory.Repo

  @valid_attrs %{content: "some content"}
  @invalid_attrs %{}

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  defp relationships do
    owner = Repo.insert!(%Inventory.User{})
    room = Repo.insert!(%Inventory.Room{})

    %{
      "owner" => %{
        "data" => %{
          "type" => "users",
          "id" => owner.id
        }
      },
      "room" => %{
        "data" => %{
          "type" => "rooms",
          "id" => room.id
        }
      },
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_v1_message_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    message = Repo.insert! %Message{}
    conn = get conn, api_v1_message_path(conn, :show, message)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{message.id}"
    assert data["type"] == "message"
    assert data["attributes"]["content"] == message.content
    assert data["attributes"]["owner_id"] == message.owner_id
    assert data["attributes"]["room_id"] == message.room_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, api_v1_message_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, api_v1_message_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "messages",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Message, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, api_v1_message_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "messages",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    message = Repo.insert! %Message{}
    conn = put conn, api_v1_message_path(conn, :update, message), %{
      "meta" => %{},
      "data" => %{
        "type" => "messages",
        "id" => message.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Message, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    message = Repo.insert! %Message{}
    conn = put conn, api_v1_message_path(conn, :update, message), %{
      "meta" => %{},
      "data" => %{
        "type" => "messages",
        "id" => message.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    message = Repo.insert! %Message{}
    conn = delete conn, api_v1_message_path(conn, :delete, message)
    assert response(conn, 204)
    refute Repo.get(Message, message.id)
  end

end
