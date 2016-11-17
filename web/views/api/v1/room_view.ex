defmodule Inventory.Api.V1.RoomView do
  use Inventory.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name]
  has_one :owner, link: :user_link

  def user_link(room, conn) do
    api_v1_user_url(conn, :show, room.owner_id)
  end

end
