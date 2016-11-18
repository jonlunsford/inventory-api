defmodule Inventory.Api.V1.CategoryView do
  use Inventory.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :inserted_at, :updated_at]
  
  has_one :company,
    field: :company_id,
    type: "company"

end
