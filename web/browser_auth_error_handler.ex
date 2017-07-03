defmodule Inventory.BrowserAuthErrorHandler do
  use Inventory.Web, :controller

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> put_flash(:error, "Authentication required")
    |> redirect(to: session_path(conn, :new))
  end

  def unauthorized(conn, _params) do
    conn
    |> put_status(403)
    |> put_flash(:error, "Authentication required")
    |> redirect(to: session_path(conn, :new))
  end

  def no_resource(conn, _params) do
    conn
    |> put_status(401)
    |> put_flash(:error, "Authentication required")
    |> redirect(to: session_path(conn, :new))
  end
end
