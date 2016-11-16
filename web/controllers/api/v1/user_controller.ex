defmodule Inventory.Api.V1.UserController do
  use Inventory.Web, :controller

  alias Inventory.User

  plug Guardian.Plug.EnsureAuthenticated, handler: Inventory.AuthErrorHandler

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, Inventory.UserView, "index.json-api", data: users)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, Inventory.UserView, data: user)
  end

  def current(conn, _) do
    user = conn |> Guardian.Plug.current_resource
    render(conn, Inventory.UserView, "show.json-api", data: user)
  end
end
