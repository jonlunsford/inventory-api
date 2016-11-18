defmodule Inventory.Api.V1.RoomController do
  use Inventory.Web, :controller

  alias Inventory.Room

  plug Guardian.Plug.EnsureAuthenticated, handler: Inventory.AuthErrorHandler

  def index(conn, %{user_id: user_id}) do
    IO.inspect user_id
    query = from r in "rooms", where: r.owner_id == ^user_id, preload: [:messages]
    rooms = query |> Repo.all

    render(conn, "index.json-api", data: rooms)
  end

  def index(conn, _params) do
    query = from r in Room, preload: [:messages]
    rooms = query |> Repo.all
    render(conn, "index.json-api", data: rooms)
  end

  def create(conn, %{"data" => %{"type" => "rooms", "attributes" => room_params, "relationships" => _}}) do
    current_user = Guardian.Plug.current_resource(conn)
    changeset = Room.changeset(%Room{owner_id: current_user.id}, room_params)

    case Repo.insert(changeset) do
      {:ok, room} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", api_v1_room_path(conn, :show, room))
        |> render("show.json-api", data: (room |> Repo.preload(:messages)))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    room =
      Repo.get!(Room, id)
      |> Repo.preload(:messages)

    render(conn, "show.json-api", data: room)
  end

  def update(conn, %{"id" => id, "data" => %{"id" => _, "type" => "rooms", "attributes" => room_params}}) do
    current_user = Guardian.Plug.current_resource(conn)

    room = Room
           |> where(owner_id: ^current_user.id, id: ^id)
           |> Repo.one!
           |> Repo.preload(:messages)

    changeset = Room.changeset(room, room_params)

    case Repo.update(changeset) do
      {:ok, room} ->
        conn
        |> render("show.json-api", data: room)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json-api", data: changeset)
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
