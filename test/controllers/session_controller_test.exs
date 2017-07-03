defmodule Inventory.SessionControllerTest do
  use ExUnit.Case
  use Inventory.ConnCase

  alias Inventory.User
  alias Inventory.Repo

  @valid_attrs %{
    email: "test@example.com",
    password: "password",
    password_confirmation: "password"
  }

  @invalid_attrs %{
    email: "broken@broken.com",
    password: "broken"
  }

  describe "new/2" do
    test "Renders the new template", %{conn: conn} do
      conn = get conn, session_path(conn, :new)
      assert html_response(conn, 200)
    end
  end

  describe "create/2" do
    test "With valid attributes logs in a user", %{conn: conn} do
      User.changeset(%User{}, @valid_attrs) |> Repo.insert!

      conn = post conn, session_path(conn, :create), user: @valid_attrs

      assert html_response(conn, 302) =~ company_path(conn, :index)
    end

    test "With invalid attributes renders the new template", %{conn: conn} do
      User.changeset(%User{}, @valid_attrs) |> Repo.insert!

      conn = post conn, session_path(conn, :create), user: @invalid_attrs

      assert html_response(conn, 422) =~ "Email or password is invalid"
    end
  end
end
