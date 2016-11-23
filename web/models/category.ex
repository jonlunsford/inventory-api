defmodule Inventory.Category do
  use Inventory.Web, :model

  schema "categories" do
    field :name, :string
    belongs_to :company, Inventory.Company

    has_many :products_categories, Inventory.ProductCategory
    has_many :products, through: [:products_categories, :product]

    has_many :categories_inputs, Inventory.CategoryInput
    has_many :inputs, through: [:categories_inputs, :input]

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :company_id])
    |> validate_required([:name])
  end
end
