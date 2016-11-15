defmodule Inventory.Api.V1.UserController do
  use Inventory.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: Inventory.AuthErrorHandler

  def current(conn, _) do
    user = conn
           |> Guardian.Plug.current_resource

    conn
    |> render(Inventory.UserView, "show.json", user: user)
  end
end
