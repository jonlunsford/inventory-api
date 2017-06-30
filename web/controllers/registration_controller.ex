defmodule Inventory.RegistrationController do
  use Inventory.Web, :controller

  alias Inventory.User
  alias Inventory.Repo
  alias Inventory.RegistrationView

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, :new, changeset: changeset
  end

  def create(conn, %{"user" => params }) do
    changeset = User.changeset(%User{}, params)

    case Repo.insert changeset do
      {:ok, _user} ->
        conn
        |> put_status(:created)
        |> redirect(to: session_path(conn, :new))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_flash(:error, "Ooops, looks like we ran into some errors :|")
        |> render(RegistrationView, :new, changeset: changeset)
    end
  end
end
