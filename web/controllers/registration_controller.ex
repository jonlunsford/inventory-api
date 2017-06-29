defmodule Inventory.RegistrationController do
  use Inventory.Web, :controller

  def new(conn, _params) do
    render conn, :new
  end
end
