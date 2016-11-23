defmodule Inventory.Api.V1.CategoryView do
  use Inventory.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name]

  has_one :company,
    field: :company_id,
    type: "company"

  has_many :products, link: :products_link

  def products_link(category, conn) do
     api_v1_category_products_path(conn, :index, category.id)
  end

end
