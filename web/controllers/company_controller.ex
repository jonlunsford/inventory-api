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

  def show(conn, %{"id" => id}, current_user) do
    company = Repo.get_by(Company, owner_id: current_user.id, id: id)
    render(conn, :show, company: company)
  end

  def edit(conn, %{"id" => id}, current_user) do
    company = Repo.get_by(Company, owner_id: current_user.id, id: id)
    changeset = Company.changeset(company)
    render(conn, :edit, company: company, changeset: changeset)
  end

  def update(conn, %{"id" => id, "company" => params}, current_user) do
    company = Repo.get_by(Company, owner_id: current_user.id, id: id)
    changeset = Company.changeset(company, params)

    case Repo.update(changeset) do
      {:ok, company} ->
        conn
        |> put_status(:ok)
        |> put_flash(:info, "Updated Company: " <> company.title)
        |> redirect(to: company_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_flash(:error, "Ooops we ran into some errors :|")
        |> render(:edit, company: company, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    company = Repo.get_by(Company, owner_id: current_user.id, id: id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(company)

    conn
    |> put_flash(:info, "Company deleted successfully.")
    |> redirect(to: company_path(conn, :index))
  end
end
