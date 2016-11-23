defmodule Inventory.Api.V1.ProductView do
  use Inventory.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :inserted_at, :updated_at]
  

end
