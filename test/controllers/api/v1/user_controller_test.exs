defmodule Inventory.Api.V1.UserControllerTest do
  use ExUnit.Case
  use Inventory.ConnCase

  alias Inventory.User
  alias Inventory.Repo

  setup %{conn: conn} do
    User.changeset(%User{}, %{email: "test@example.com", password: "password", password_confirmation: "password"})
    |> Repo.insert!

    on_exit fn ->
      Ecto.Adapters.SQL.Sandbox.checkout(Repo)

      Inventory.Repo.delete_all(User)
    end

    { :ok, conn: put_req_header(conn, "accept", "application/json") }
  end

end
