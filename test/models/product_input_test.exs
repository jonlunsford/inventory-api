defmodule Inventory.ProductInputTest do
  use Inventory.ModelCase

  alias Inventory.ProductInput

  @valid_attrs %{input_id: 1, product_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ProductInput.changeset(%ProductInput{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ProductInput.changeset(%ProductInput{}, @invalid_attrs)
    refute changeset.valid?
  end
end
