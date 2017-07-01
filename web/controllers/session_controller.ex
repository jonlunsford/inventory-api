defmodule Inventory.SessionController do
  use Inventory.Web, :controller

  def new(conn, _params) do
    render conn, :new
  end
end
