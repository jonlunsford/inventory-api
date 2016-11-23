defmodule Inventory.ProductCategory do
  use Inventory.Web, :model

  schema "products_categories" do
    belongs_to :product, Inventory.Product
    belongs_to :category, Inventory.Category

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:product_id, :category_id])
    |> validate_required([:product_id, :category_id])
    |> foreign_key_constraint(:category_id)
    |> foreign_key_constraint(:product_id)
    |> unique_constraint(:product_id_category_id)
  end
end
