defmodule Inventory.SessionControllerTest do
  use ExUnit.Case
  use Inventory.ConnCase

  alias Inventory.User
  alias Inventory.Repo

  setup %{conn: conn} do
    User.changeset(%User{}, %{email: "test@example.com", password: "password", password_confirmation: "password"})
    |> Repo.insert!

    { :ok, conn: conn }
  end

  describe "new/2" do
    test "Renders the new template", %{conn: conn} do
      conn = get conn, session_path(conn, :new)
      assert html_response(conn, 200)
    end
  end
end
