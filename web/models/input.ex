defmodule Inventory.Input do
  use Inventory.Web, :model

  schema "inputs" do
    field :name, :string
    field :label, :string
    field :value, :string
    field :disabled, :boolean, default: false
    field :meta, :map
    field :input_type, :string

    belongs_to :product, Inventory.Product
    belongs_to :category, Inventory.Category
    has_one :address, Inventory.Address

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :label, :value, :disabled, :meta, :input_type, :category_id, :product_id])
    |> validate_required([:name, :label, :value, :disabled, :meta, :input_type])
  end
end
