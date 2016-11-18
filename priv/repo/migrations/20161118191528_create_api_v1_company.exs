defmodule Inventory.Repo.Migrations.CreateApi.V1.Company do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :title, :string
      add :owner_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:companies, [:owner_id])
  end
end
