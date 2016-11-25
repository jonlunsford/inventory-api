defmodule Inventory.Repo.Migrations.AddTimestampsToCategories do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      modify :inserted_at, :datetime, default: fragment("NOW()")
      modify :updated_at, :datetime, default: fragment("NOW()")
    end
  end
end
