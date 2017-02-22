defmodule Inventory.Repo.Migrations.RemoveProductsCategeoriesCategoryIdForeignKeyConstraint do
  use Ecto.Migration

  def change do
    drop_if_exists index(:products_categories, [:category_id])
    drop constraint(:products_categories, "products_categories_category_id_fkey")
    alter table(:products_categories) do
      modify :category_id, references(:categories, on_delete: :nilify_all)
    end
  end
end
