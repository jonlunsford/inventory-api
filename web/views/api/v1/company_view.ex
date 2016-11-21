defmodule Inventory.Api.V1.CompanyView do
  use Inventory.Web, :view
  use JaSerializer.PhoenixView

  attributes [:title]
  has_one :owner, link: :user_link
  has_many :categories, link: :categories_link

  def user_link(company, conn) do
    api_v1_user_url(conn, :show, company.owner_id)
  end

  def categories_link(company, conn) do
    api_v1_user_companies_categories_url(conn, :index, company.owner_id, company.id )
  end
end
