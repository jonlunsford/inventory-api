defmodule Inventory.Api.V1.UserView do
  use Inventory.Web, :view
  use JaSerializer.PhoenixView

  attributes [:email]
  has_many :rooms, link: :rooms_link
  has_many :messages

  def rooms_link(user, conn) do
    api_v1_user_rooms_url(conn, :index, user.id)
  end
end