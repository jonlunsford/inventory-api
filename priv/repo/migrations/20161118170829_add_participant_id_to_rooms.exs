defmodule Inventory.Repo.Migrations.AddParticipantIdToRooms do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :participant_id, references(:users, on_delete: :nothing)
    end

    create index(:rooms, [:participant_id])
  end
end
