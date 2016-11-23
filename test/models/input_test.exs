defmodule Inventory.Api.V1.InputTest do
  use Inventory.ModelCase

  alias Inventory.Input

  @valid_attrs %{disabled: true, label: "some content", meta: %{}, name: "some content", value: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Input.changeset(%Input{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Input.changeset(%Input{}, @invalid_attrs)
    refute changeset.valid?
  end
end
