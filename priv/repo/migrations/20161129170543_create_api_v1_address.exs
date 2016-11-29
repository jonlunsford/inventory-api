defmodule Inventory.Repo.Migrations.CreateApi.V1.Address do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :city, :string
      add :state, :string
      add :country, :string
      add :zip, :integer
      add :lat, :float
      add :long, :float
      add :line_1, :string
      add :line_2, :string
      add :phone, :string
      add :description, :text
      add :company_id, references(:companies, on_delete: :nothing)
      add :input_id, references(:inputs, on_delete: :nothing)

      timestamps()
    end
    create index(:addresses, [:company_id])
    create index(:addresses, [:input_id])

  end
end
