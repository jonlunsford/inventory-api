defmodule Inventory.Product do
  use Inventory.Web, :model

  schema "products" do
    field :name, :string

    has_many :products_categories, Inventory.ProductCategory
    has_many :categories, through: [:products_categories, :category]

    has_many :products_inputs, Inventory.ProductInput
    has_many :inputs, through: [:products_inputs, :input]

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
