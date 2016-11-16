defmodule Inventory.Api.V1.RegistrationController do
  use Inventory.Web, :controller

  alias Inventory.User
  alias Inventory.Repo

  def create(conn, %{"data" => %{"type" => "users", "attributes" => params }}) do
    changeset = User.changeset(%User{}, params)

    case Repo.insert changeset do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(Inventory.UserView, "show.json-api", data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Inventory.UserView, "errors.json-api", changeset: changeset)
    end
  end
end
