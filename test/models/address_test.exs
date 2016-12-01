defmodule Inventory.AddressTest do
  use Inventory.ModelCase

  alias Inventory.Address

  @valid_attrs %{city: "some content", country: "some content", description: "some content", lat: "120.5", line1: "some content", line2: "some content", long: "120.5", phone: "some content", state: "some content", zip: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Address.changeset(%Address{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Address.changeset(%Address{}, @invalid_attrs)
    refute changeset.valid?
  end
end

