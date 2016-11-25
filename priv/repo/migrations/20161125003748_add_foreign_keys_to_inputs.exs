defmodule Inventory.Repo.Migrations.AddForeignKeysToInputs do
  use Ecto.Migration

  def change do
    alter table(:inputs) do
      add :product_id, references(:products, on_delete: :nothing)
      add :category_id, references(:categories, on_delete: :nothing)
    end

    create index(:inputs, [:category_id])
    create index(:inputs, [:product_id])
  end
end
