defmodule Inventory.Api.V1.CategoryTest do
  use Inventory.ModelCase

  alias Inventory.Category
  alias Inventory.Company

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Category.changeset(%Category{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Category.changeset(%Category{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "company relationships" do
    company = Repo.insert! %Company{}
    category = Repo.insert! %Category{company: company}

    result =
      Repo.get(Category, category.id)
      |> Repo.preload(:company)

    assert result.company.id == company.id
  end
end
