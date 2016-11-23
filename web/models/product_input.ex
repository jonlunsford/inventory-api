defmodule Inventory.ProductInput do
  use Inventory.Web, :model

  schema "products_inputs" do
    belongs_to :product, Inventory.Product
    belongs_to :input, Inventory.Input

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:product_id, :input_id])
    |> validate_required([:product_id, :input_id])
    |> foreign_key_constraint(:input_id)
    |> foreign_key_constraint(:product_id)
    |> unique_constraint(:product_id_input_id)
  end
end
