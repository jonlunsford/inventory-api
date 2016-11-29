defmodule Inventory.Api.V1.InputView do
  use Inventory.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :label, :value, :disabled, :meta, :input_type]
  has_one :product,
  field: :product_id,
  type: "product"
end
