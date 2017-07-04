defmodule Inventory.CompanyControllerTest do
  use ExUnit.Case
  use Inventory.ConnCase, async: true

  alias Inventory.User
  alias Inventory.Company

  @valid_user_attrs %{
    email: "test@example.com",
    password: "password",
    password_confirmation: "password"
  }

  @valid_attrs %{title: "some company title"}

  setup %{conn: conn} do
    user =
      case Repo.get_by(User, email: "test@test.com") do
        {:ok, result} -> result
        nil ->
          User.changeset(%User{}, @valid_user_attrs)
          |> Ecto.Changeset.put_assoc(:companies, [Company.changeset(%Company{}, %{title: "Owned"})])
          |> Repo.insert!
      end

    conn =
      conn
      |> sign_in(user)

    {:ok, %{conn: conn, user: user}}
  end

  describe "index/3" do
    test "Redirects to Session.new if user is not logged in", %{conn: conn} do
      conn =
        conn
        |> Guardian.Plug.sign_out
        |> get(company_path(conn, :index))

      assert redirected_to(conn, 401) =~ session_path(conn, :new)
    end

    test "Lists companies owned by user if user is logged in", %{conn: conn, user: user} do
      conn = get conn, company_path(conn, :index)

      assert html_response(conn, 200)
      assert Enum.count(conn.assigns.companies) == 1
      assert List.first(conn.assigns.companies) == List.first(user.companies)
    end

    test "Returns 200 ok if user is logged in", %{conn: conn} do
      conn = get conn, company_path(conn, :index)

      assert html_response(conn, 200)
    end
  end

  describe "create/3" do
    test "with valid attributes creates and redirects to index/3", %{conn: conn} do
      conn = post conn, company_path(conn, :create), %{company: @valid_attrs}

      assert redirected_to(conn, 201) =~ company_path(conn, :index)
      assert Repo.get_by(Company, @valid_attrs)
    end

    test "withh invalid attributes renders new/3", %{conn: conn} do
      conn = post conn, company_path(conn, :create), %{company: %{title: ""}}

      assert html_response(conn, 422)
      refute Enum.empty?(conn.assigns.changeset.errors)
    end
  end

  describe "update/3" do
    test "with valid attributes updates and redirects to index/3", %{conn: conn, user: user} do
      company = List.first(user.companies)
      conn = patch conn, company_path(conn, :update, company), %{company: %{title: "Update"}}

      assert redirected_to(conn, 200) =~ company_path(conn, :index)
      assert Repo.get_by(Company, %{title: "Update"})
    end

    test "with invalid attributes renders edit/3", %{conn: conn, user: user} do
      company = List.first(user.companies)
      conn = patch conn, company_path(conn, :update, company), %{company: %{title: ""}}

      assert html_response(conn, 422)
      refute Enum.empty?(conn.assigns.changeset.errors)
    end
  end
end
