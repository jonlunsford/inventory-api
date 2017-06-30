defmodule Inventory.RegistrationControllerTest do
  use ExUnit.Case
  use Inventory.ConnCase, async: true

  alias Inventory.User

  @valid_attrs %{
    email: "test@test.com",
    password: "password",
    password_confirmation: "password"
  }

  @invalid_attrs %{}

  setup %{conn: conn} do
    on_exit fn ->
      Ecto.Adapters.SQL.Sandbox.checkout(Inventory.Repo)

      Inventory.Repo.delete_all(User)
    end

    {:ok, conn: conn}
  end

  describe "new/2" do
    test "Renders the new template", %{conn: conn} do
      conn = get conn, :registration
      assert html_response(conn, 200)
    end

    test "Does not render error messages from default changeset", %{conn: conn} do
      conn = get conn, :registration

      refute html_response(conn, 200) =~ "Email can&#39;t be blank"
      refute html_response(conn, 200) =~ "Password can&#39;t be blank"
      refute html_response(conn, 200) =~ "Password confirmation can&#39;t be blank"
    end
  end

  describe "create/2" do
    test "with valid attributes creates a new user", %{conn: conn} do
      conn = post conn, registration_path(conn, :create), %{ "user" => @valid_attrs }

      assert redirected_to(conn, 201) =~ session_path(conn, :new)
    end

    test "with invalid attributes renders the new view with errors", %{conn: conn} do
      conn = post conn, registration_path(conn, :create), %{ "user" => @invalid_attrs }

      assert html_response(conn, 422) =~ "Email can&#39;t be blank"
      assert html_response(conn, 422) =~ "Password can&#39;t be blank"
      assert html_response(conn, 422) =~ "Password confirmation can&#39;t be blank"
    end
  end
end
