defmodule Inventory.Repo.Migrations.AddRoomIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :room_id, references(:rooms, on_delete: :nothing)
    end
  end
end
