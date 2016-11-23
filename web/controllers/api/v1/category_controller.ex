defmodule Inventory.Api.V1.CategoryController do
  use Inventory.Web, :controller

  alias Inventory.Category
  alias Inventory.CategoryInput
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, %{"user_id" => _user_id, "company_id" => company_id}) do
    categories = Category
      |> where(company_id: ^company_id)
      |> Repo.all

    render(conn, "index.json-api", data: categories)
  end

  def index(conn, _params) do
    categories = Repo.all(Category)
    render(conn, "index.json-api", data: categories)
  end

  def create(conn, %{"data" => data = %{"type" => "categories", "attributes" => _category_params}}) do
    params = Params.to_attributes(data)
    changeset = Category.changeset(%Category{company_id: params["company_id"]}, params)

    case Repo.insert(changeset) do
      {:ok, category} ->
        category |> associate_inputs(params)

        conn
        |> put_status(:created)
        |> put_resp_header("location", api_v1_category_path(conn, :show, category))
        |> render("show.json-api", data: (category |> Repo.preload(:company)))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)
    render(conn, "show.json-api", data: category)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "categories", "attributes" => _category_params}}) do
    category = Repo.get!(Category, id)
    changeset = Category.changeset(category, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, category} ->
        render(conn, "show.json-api", data: category)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(category)

    send_resp(conn, :no_content, "")
  end

  def associate_inputs(category, %{"inputs_ids" => inputs_ids}) do
    inputs_ids
    |> Enum.each(fn(id) -> associate_input(category, id) end)
  end

  def associate_inputs(_, _), do: :noop

  def associate_input(category, input_id) do
    CategoryInput.changeset(%CategoryInput{}, %{ category_id: category.id, input_id: input_id })
    |> Repo.insert
  end

end
