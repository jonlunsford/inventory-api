defmodule Inventory.CategoryInput do
  use Inventory.Web, :model

  schema "categories_inputs" do
    belongs_to :category, Inventory.Category
    belongs_to :input, Inventory.Input

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:input_id, :category_id])
    |> validate_required([:input_id, :category_id])
    |> foreign_key_constraint(:category_id)
    |> foreign_key_constraint(:input_id)
    |> unique_constraint(:product_id_input_id)
  end
end
