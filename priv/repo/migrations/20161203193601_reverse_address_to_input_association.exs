defmodule Inventory.Repo.Migrations.ReverseAddressToInputAssociation do
  use Ecto.Migration

  def change do
    alter table(:addresses) do
      remove :input_id
    end

    alter table(:inputs) do
      add :address_id, references(:addresses, on_delete: :delete_all)
    end

    create index(:inputs, :address_id)
  end
end
