defmodule Inventory.MessageTest do
  use Inventory.ModelCase

  alias Inventory.Message

  @valid_attrs %{content: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Message.changeset(%Message{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Message.changeset(%Message{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "inserting with relationships" do
    owner = Repo.insert!(%Inventory.User{})
    room = Repo.insert!(%Inventory.Room{})

    message =
      %Message{owner_id: owner.id, room_id: room.id}
      |> Repo.insert!
      |> Repo.preload([:owner, :room])

    assert message.owner.id == owner.id
    assert message.room.id == room.id
  end
end
