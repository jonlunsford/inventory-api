defmodule Inventory.Product do
  use Inventory.Web, :model

  schema "products" do
    field :name, :string

    has_many :products_categories, Inventory.ProductCategory, on_delete: :nilify_all
    has_many :categories, through: [:products_categories, :category]

    has_many :inputs, Inventory.Input, on_delete: :delete_all

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
