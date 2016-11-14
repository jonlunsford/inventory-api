defmodule Inventory.Api.V1.SessionController do
  use Inventory.Web, :controller

  def index(conn, _params) do
    conn
    |> json(%{status: "OK"})
  end
end
