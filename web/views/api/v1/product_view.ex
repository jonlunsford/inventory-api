defmodule Inventory.Api.V1.ProductView do
  use Inventory.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name]

  has_many :inputs, link: :inputs_link

  def inputs_link(product, conn) do
     api_v1_product_inputs_url(conn, :index, product.id)
  end

end
