defmodule Inventory.Api.V1.InputView do
  use Inventory.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :label, :value, :disabled, :meta, :inserted_at, :updated_at]
  

end
