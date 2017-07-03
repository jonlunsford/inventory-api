defmodule Inventory.SessionController do
  use Inventory.Web, :controller

  alias Inventory.User

  def new(conn, _params) do
    render conn, :new
  end

  def create(conn, %{"user" => params}) do
    case User.find_and_confirm_password(params) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Signed in successfully")
        |> redirect(to: company_path(conn, :index))
      {:error, reason} ->
        conn
        |> put_status(422)
        |> put_flash(:error, reason)
        |> render(:new)
    end
  end
end
