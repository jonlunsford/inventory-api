defmodule Inventory.Category do
  use Inventory.Web, :model

  schema "categories" do
    field :name, :string

    belongs_to :company, Inventory.Company, on_replace: :delete
    has_many :products_categories, Inventory.ProductCategory
    has_many :products, through: [:products_categories, :product], on_delete: :delete_all

    has_many :inputs, Inventory.Input
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
