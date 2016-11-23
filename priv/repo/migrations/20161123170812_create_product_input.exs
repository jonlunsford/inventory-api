defmodule Inventory.Repo.Migrations.CreateProductInput do
  use Ecto.Migration

  def change do
    create table(:products_inputs) do
      add :product_id, references(:products, on_delete: :nothing)
      add :input_id, references(:inputs, on_delete: :nothing)

      timestamps()
    end

    create index(:products_inputs, [:product_id, :input_id], unique: true)
  end
end
