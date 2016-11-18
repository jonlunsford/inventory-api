defmodule Inventory.Api.V1.CompanyView do
  use Inventory.Web, :view
  use JaSerializer.PhoenixView

  attributes [:title]
  has_one :owner, link: :user_link

  def user_link(company, conn) do
    api_v1_user_url(conn, :show, company.owner_id)
  end
end
