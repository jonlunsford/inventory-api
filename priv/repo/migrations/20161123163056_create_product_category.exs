defmodule Inventory.Repo.Migrations.CreateProductCategory do
  use Ecto.Migration

  def change do
    create table(:products_categories) do
      add :product_id, references(:products, on_delete: :nothing)
      add :category_id, references(:categories, on_delete: :nothing)

      timestamps()
    end

    create index(:products_categories, [:product_id, :category_id], unique: true)
  end
end
