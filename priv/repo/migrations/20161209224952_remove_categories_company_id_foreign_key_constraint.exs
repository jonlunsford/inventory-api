defmodule Inventory.Repo.Migrations.RemoveCategoriesCompanyIdForeignKeyConstraint do
  use Ecto.Migration

  def change do
    drop_if_exists index(:categories, [:company_id])
    drop constraint(:categories, "categories_company_id_fkey")
    alter table(:categories) do
      modify :company_id, references(:companies, on_delete: :delete_all)
    end
  end
end
