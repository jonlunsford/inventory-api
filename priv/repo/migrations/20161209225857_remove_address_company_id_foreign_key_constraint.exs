defmodule Inventory.Repo.Migrations.RemoveAddressCompanyIdForeignKeyConstraint do
  use Ecto.Migration

  def change do
    drop_if_exists index(:addresses, [:company_id])
    drop constraint(:addresses, "addresses_company_id_fkey")
    alter table(:addresses) do
      modify :company_id, references(:companies, on_delete: :delete_all)
    end

  end
end
