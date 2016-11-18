defmodule Inventory.RoomTest do
  use Inventory.ModelCase

  alias Inventory.Room
  alias Inventory.User

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Room.changeset(%Room{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Room.changeset(%Room{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "user relationships" do
    participant = Repo.insert! %User{}
    owner = Repo.insert! %User{}
    room = Repo.insert! %Room{owner: owner, participant: participant}

    result =
      Repo.get(Room, room.id)
      |> Repo.preload([:owner, :participant])

    assert result.owner.id == owner.id
    assert result.participant.id == participant.id
  end
end
