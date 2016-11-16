defmodule Inventory.Api.V1.SessionController do
  use Inventory.Web, :controller

  alias Inventory.User

  import Ecto.Query, only: [where: 2]
  import Comeonin.Bcrypt

  def create(conn, %{"grant_type" => "password",
    "username" => username,
    "password" => password }) do

    try do
      user = User
      |> where(email: ^username)
      |> Repo.one!

      cond do
        checkpw(password, user.password_hash) ->
          { :ok, jwt, _} = Guardian.encode_and_sign(user, :token)

          conn
          |> json(%{access_token: jwt})

        true ->
          conn
          |> put_status(401)
          |> render(Inventory.ErrorView, "401.json")
      end
    rescue
      e ->

        IO.inspect e
        conn
        |> put_status(401)
        |> render(Inventory.ErrorView, "401.json")
    end
  end

  def create(_conn, %{"grant_type" => _}) do
    throw "Unsupported grant_type"
  end
end
