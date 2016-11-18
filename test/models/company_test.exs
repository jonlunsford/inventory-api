defmodule Inventory.Api.V1.CompanyTest do
  use Inventory.ModelCase

  alias Inventory.Company
  alias Inventory.User

  @valid_attrs %{title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Company.changeset(%Company{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Company.changeset(%Company{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "user relationships" do
    owner = Repo.insert! %User{}
    company = Repo.insert! %Company{owner: owner}

    result =
      Repo.get(Company, company.id)
      |> Repo.preload([:owner])

    assert result.owner.id == owner.id
  end

end
