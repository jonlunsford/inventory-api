defmodule Inventory.Input do
  use Inventory.Web, :model

  schema "inputs" do
    field :name, :string
    field :label, :string
    field :value, :string
    field :disabled, :boolean, default: false
    field :meta, :map
    field :input_type, :string

    has_many :products_inputs, Inventory.ProductInput
    has_many :products, through: [:products_inputs, :product]

    has_many :categories_inputs, Inventory.CategoryInput
    has_many :categories, through: [:categories_inputs, :category]

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :label, :value, :disabled, :meta, :input_type])
    |> validate_required([:name, :label, :value, :disabled, :meta, :input_type])
  end
end
