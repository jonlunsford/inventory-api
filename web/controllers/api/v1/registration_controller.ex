defmodule Inventory.Api.V1.RegistrationController do
  use Inventory.Web, :controller

  alias Inventory.User
  alias Inventory.Repo
  alias Inventory.Api.V1.UserView

  def create(conn, %{"data" => %{"type" => "users", "attributes" => params }}) do
    changeset = User.changeset(%User{}, params)

    case Repo.insert changeset do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(UserView, "show.json-api", data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(UserView, "errors.json-api", data: changeset)
    end
  end
end
