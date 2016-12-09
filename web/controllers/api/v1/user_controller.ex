defmodule Inventory.Api.V1.UserController do
  use Inventory.Web, :controller
  use Inventory.Api.V1.ApplicationController

  alias Inventory.User

  plug Guardian.Plug.EnsureAuthenticated, handler: Inventory.AuthErrorHandler

  def index(conn, _params, _current_user) do
    users = Repo.all(User)
    render(conn, "index.json-api", data: users)
  end

  def show(conn, %{"id" => id}, _current_user) do
    user = Repo.get!(User, id)
    render(conn, "show.json-api", data: user)
  end

  def current(conn, _params, current_user) do
    IO.inspect current_user
    render(conn, "show.json-api", data: current_user)
  end

  def delete(conn, %{"id" => id}, _current_user) do
    user = Repo.get!(User, id)

    Repo.delete!(user)
    send_resp(conn, :no_content, "")
  end
end
