defmodule Inventory.Repo.Migrations.RemoveUnderscoresFromAddressLineColumns do
  use Ecto.Migration

  def change do
    rename table(:addresses), :line_1, to: :line1
    rename table(:addresses), :line_2, to: :line2
  end
end
