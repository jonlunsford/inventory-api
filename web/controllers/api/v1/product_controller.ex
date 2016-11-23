defmodule Inventory.Api.V1.ProductController do
  use Inventory.Web, :controller

  alias Inventory.Product
  alias Inventory.ProductCategory
  alias Inventory.Category
  alias Inventory.ProductInput
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, %{"category_id" => category_id}) do
    assoc =
      Repo.get(Category, category_id)
      |> Repo.preload(:products)

    render(conn, "index.json-api", data: assoc.products)
  end

  def index(conn, _params) do
    products = Repo.all(Product)
    render(conn, "index.json-api", data: products)
  end

  def create(conn, %{"data" => data = %{"type" => "products", "attributes" => _product_params}}) do
    params = Params.to_attributes(data)
    changeset = Product.changeset(%Product{}, params)

    case Repo.insert(changeset) do
      {:ok, product} ->
        product |> associate_inputs(params)
        product |> associate_categories(params)

        conn
        |> put_status(:created)
        |> put_resp_header("location", api_v1_product_path(conn, :show, product))
        |> render("show.json-api", data: product)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    product = Repo.get!(Product, id)
    render(conn, "show.json-api", data: product)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "products", "attributes" => _product_params}}) do
    product = Repo.get!(Product, id)
    changeset = Product.changeset(product, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, product} ->
        render(conn, "show.json-api", data: product)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    product = Repo.get!(Product, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(product)

    send_resp(conn, :no_content, "")
  end

  def associate_inputs(product, %{"inputs_ids" => inputs_ids}) do
    inputs_ids
    |> Enum.each(fn(id) -> associate_input(product, id) end)
  end

  def associate_inputs(_, _), do: :noop

  def associate_input(product, input_id) do
    ProductInput.changeset(%ProductInput{}, %{ product_id: product.id, input_id: input_id })
    |> Repo.insert
  end

  def associate_categories(product, %{"categories_ids" => categories_ids}) do
    categories_ids
    |> Enum.each(fn(id) -> associate_category(product, id) end)
  end

  def associate_categories(_, _), do: :noop

  def associate_category(product, category_id) do
    ProductCategory.changeset(%ProductCategory{}, %{ product_id: product.id, category_id: category_id })
    |> Repo.insert
  end

end
