defmodule Inventory.Api.V1.MessageView do
  use Inventory.Web, :view
  use JaSerializer.PhoenixView

  attributes [:content, :inserted_at]
end
