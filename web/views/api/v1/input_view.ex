defmodule Inventory.Api.V1.InputView do
  use Inventory.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :label, :value, :disabled, :meta, :input_type]

  has_one :product,
  field: :product_id,
  type: "product"

  has_one :address, link: :address_link

  def address_link(input, conn) do
    api_v1_input_address_url(conn, :index, input.id)
  end
end
