defmodule Inventory.Repo.Migrations.AddTypeToInputs do
  use Ecto.Migration

  def change do
    alter table(:inputs) do
      add :input_type, :string
    end
  end
end
