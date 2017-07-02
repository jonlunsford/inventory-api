defmodule Inventory.UserTest do
  use Inventory.ModelCase

  alias Inventory.User

  @valid_attrs %{email: "test@test.com", password: "password", password_confirmation: "password"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with invalid email" do
    changeset = User.changeset(%User{}, %{email: "test", password: "password", password_confirmation: "password"})
    refute changeset.valid?
  end

  test "changeset with invalid pw length" do
    changeset = User.changeset(%User{}, %{email: "test@test.com", password: "pass", password_confirmation: "pass"})
    refute changeset.valid?
  end

  test "changeset invalild with missing password_confirmation" do
    changeset = User.changeset(%User{}, %{email: "test@test.com", password: "password"})
    refute changeset.valid?
  end

  test "changeset with non unique email" do
    user = %User{ email: "test@test.com", password: "password" } |> Inventory.Repo.insert!

    result = %User{email: "test@test.com", password: "password", password_confirmation: "password"}
    assert result.inserted_at == nil

    Inventory.Repo.delete(user)
  end

  describe "find_and_confirm_password/1" do
    test "With valid credentials returns {:ok, user}" do
      User.changeset(%User{}, @valid_attrs) |> Inventory.Repo.insert!

      assert {:ok, _user} = User.find_and_confirm_password(%{"email" => "test@test.com", "password" => "password" })
    end

    test "With invalid credentials returns :error" do
      assert {:error, "Email or password is invalid"} = User.find_and_confirm_password(%{"email" => "broken@test.com", "password" => "broken"})
    end
  end

end
