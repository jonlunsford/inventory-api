defmodule Inventory.Repo.Migrations.CreateCategoryInput do
  use Ecto.Migration

  def change do
    create table(:categories_inputs) do
      add :category_id, references(:categories, on_delete: :nothing)
      add :input_id, references(:inputs, on_delete: :nothing)

      timestamps()
    end
    create index(:categories_inputs, [:category_id, :input_id], unique: true)

  end
end
