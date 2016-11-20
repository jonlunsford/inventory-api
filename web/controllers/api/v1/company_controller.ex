defmodule Inventory.Api.V1.CompanyController do
  use Inventory.Web, :controller

  alias Inventory.Company
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, %{"user_id" => user_id}) do
    categories = Company
      |> where(owner_id: ^user_id)
      |> Repo.all

    render(conn, "index.json-api", data: categories)
  end

  def index(conn, _params) do
    companies = Repo.all(Company)
    render(conn, "index.json-api", data: companies)
  end

  def create(conn, %{"data" => data = %{"type" => "companies", "attributes" => _company_params}}) do
    current_user = Guardian.Plug.current_resource(conn)
    changeset = Company.changeset(%Company{owner_id: current_user.id}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, company} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", api_v1_company_path(conn, :show, company))
        |> render("show.json-api", data: company)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    company = Repo.get!(Company, id)
    render(conn, "show.json-api", data: company)
  end

  def update(conn, %{"id" => id, "data" => _data = %{"type" => "companies", "attributes" => company_params}}) do
    current_user = Guardian.Plug.current_resource(conn)

    company = Company
           |> where(owner_id: ^current_user.id, id: ^id)
           |> Repo.one!

    changeset = Company.changeset(company, company_params)

    case Repo.update(changeset) do
      {:ok, company} ->
        render(conn, "show.json-api", data: company)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)

    company = Company
           |> where(owner_id: ^current_user.id, id: ^id)
           |> Repo.one!

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(company)

    send_resp(conn, :no_content, "")
  end

end
