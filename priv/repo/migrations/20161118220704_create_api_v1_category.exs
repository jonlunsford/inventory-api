defmodule Inventory.Repo.Migrations.CreateApi.V1.Category do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :company_id, references(:companies, on_delete: :nothing)

      timestamps()
    end
    create index(:categories, [:company_id])

  end
end
