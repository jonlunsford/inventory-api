defmodule Inventory.SessionController do
  use Inventory.Web, :controller

  alias Inventory.User
  alias Inventory.ErrorView

  import Ecto.Query, only: [where: 2]
  import Comeonin.Bcrypt

  def new(conn, _params) do
    render conn, :new
  end
end
