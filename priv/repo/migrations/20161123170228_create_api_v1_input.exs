defmodule Inventory.Repo.Migrations.CreateApi.V1.Input do
  use Ecto.Migration

  def change do
    create table(:inputs) do
      add :name, :string
      add :label, :string
      add :value, :string
      add :disabled, :boolean, default: false, null: false
      add :meta, :map

      timestamps()
    end

  end
end
