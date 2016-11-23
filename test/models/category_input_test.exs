defmodule Inventory.CategoryInputTest do
  use Inventory.ModelCase

  alias Inventory.CategoryInput

  @valid_attrs %{input_id: 1, category_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CategoryInput.changeset(%CategoryInput{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CategoryInput.changeset(%CategoryInput{}, @invalid_attrs)
    refute changeset.valid?
  end
end
