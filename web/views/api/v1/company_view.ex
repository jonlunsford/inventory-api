defmodule Inventory.Api.V1.CompanyView do
  use Inventory.Web, :view
  use JaSerializer.PhoenixView

  attributes [:title, :inserted_at, :updated_at]
end
