defmodule Inventory.Api.V1.RoomController do
  use Inventory.Web, :controller

  alias Inventory.Room

  plug Guardian.Plug.EnsureAuthenticated, handler: Inventory.AuthErrorHandler

  def index(conn, %{user_id: user_id}) do
    rooms = Room
            |> where(owner_id: ^user_id)
            |> Repo.all

    render(conn, Inventory.RoomView, "index.json-api", data: rooms)
  end

  def index(conn, _params) do
    rooms = Repo.all(Room)
    render(conn, Inventory.RoomView, "index.json-api", data: rooms)
  end

  def create(conn, %{"data" => %{"type" => "rooms", "attributes" => room_params, "relationships" => _}}) do
    current_user = Guardian.Plug.current_resource(conn)
    changeset = Room.changeset(%Room{owner_id: current_user.id}, room_params)

    case Repo.insert(changeset) do
      {:ok, room} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", api_v1_room_path(conn, :show, room))
        |> render(Inventory.RoomView, "show.json-api", data: room)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Inventory.RoomView, "errors.json-api", data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    room = Repo.get!(Room, id)
    render(conn, Inventory.RoomView, "show.json-api", data: room)
  end

  def update(conn, %{"id" => id, "data" => %{"id" => _, "type" => "rooms", "attributes" => room_params}}) do
    current_user = Guardian.Plug.current_resource(conn)

    room = Room
           |> where(owner_id: ^current_user.id, id: ^id)
           |> Repo.one!

    changeset = Room.changeset(room, room_params)

    case Repo.update(changeset) do
      {:ok, room} ->
        conn
        |> render(Inventory.RoomView, "show.json-api", data: room)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Inventory.RoomView, "errors.json-api", data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)

    room = Room
           |> where(owner_id: ^current_user.id, id: ^id)
           |> Repo.one!

    Repo.delete!(room)

    send_resp(conn, :no_content, "")
  end
end
