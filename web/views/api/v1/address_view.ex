defmodule Inventory.Api.V1.AddressView do
  use Inventory.Web, :view
  use JaSerializer.PhoenixView

  attributes [:city, :state, :country, :zip, :lat, :long, :line_1, :line_2, :phone, :description, :inserted_at, :updated_at]
  
  has_one :company,
    field: :company_id,
    type: "company"
  has_one :input,
    field: :input_id,
    type: "input"

end
