defmodule Inventory.CompanyController do
  use Inventory.Web, :controller
  use Inventory.ApplicationController

  alias Inventory.Company

  def index(conn, _params, current_user) do
    companies = Company
                |> where(owner_id: ^current_user.id)
                |> Repo.all

    render(conn, :index, companies: companies)
  end
end
