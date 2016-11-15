defmodule Inventory.AuthErrorHandler do
  use Inventory.Web, :controller

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> render(Inventory.ErrorView, "401.json")
  end

  def unauthorized(conn, _params) do
    conn
    |> put_status(403)
    |> render(Inventory.ErrorView, "403.json")
  end
end
