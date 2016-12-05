defmodule Inventory.Input do
  use Inventory.Web, :model

  schema "inputs" do
    field :name, :string
    field :label, :string
    field :value, :string
    field :disabled, :boolean, default: false
    field :meta, :map
    field :input_type, :string

    belongs_to :product, Inventory.Product, on_replace: :nilify
    belongs_to :category, Inventory.Category, on_replace: :nilify
    belongs_to :address, Inventory.Address, on_replace: :nilify

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :label, :value, :disabled, :meta, :input_type, :category_id, :product_id, :address_id])
    |> validate_required([:name, :label, :disabled, :input_type])
  end
end
