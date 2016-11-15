defmodule Inventory.Api.V1.RegistrationController do
  use Inventory.Web, :controller

  alias Inventory.User
  alias Inventory.Repo

  def create(conn, %{"data" => %{"type" => "users", "attributes" =>
      %{"email" => email,
        "password" => password,
        "password-confirmation" => password_confirmation}}}) do

    changeset = User.changeset(%User{}, %{email: email, password: password, password_confirmation: password_confirmation})

    case Repo.insert changeset do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(Inventory.UserView, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Inventory.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
