defmodule Inventory.Repo.Migrations.CreateApi.V1.Product do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string

      timestamps()
    end

  end
end
