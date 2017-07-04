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

  def new(conn, _params, _current_user) do
    changeset = Company.changeset(%Company{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"company" => params}, current_user) do
    changeset = Company.changeset(%Company{owner_id: current_user.id}, params)

    case Repo.insert(changeset) do
      {:ok, company} ->
        conn
        |> put_status(:created)
        |> put_flash(:info, "Created company: " <> company.title)
        |> redirect(to: company_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_flash(:error, "Ooops we ran into some errors :|")
        |> render(:new, changeset: changeset)
    end
  end
end
