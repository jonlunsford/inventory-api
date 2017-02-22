defmodule Inventory.Repo.Migrations.RemoveInputsCategoryIdForeignKeyConstraint do
  use Ecto.Migration

  def change do
    drop_if_exists index(:inputs, [:category_id])
    drop constraint(:inputs, "inputs_category_id_fkey")
    alter table(:inputs) do
      modify :category_id, references(:categories, on_delete: :delete_all)
    end

  end
end
