defmodule Inventory.Api.V1.InputController do
  use Inventory.Web, :controller

  alias Inventory.Input
  alias Inventory.Category
  alias Inventory.Product
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, %{"category_id" => category_id}) do
    assoc =
      Repo.get(Category, category_id)
      |> Repo.preload(:inputs)

    render(conn, "index.json-api", data: assoc.inputs)
  end

  def index(conn, %{"product_id" => product_id}) do
    assoc =
      Repo.get(Product, product_id)
      |> Repo.preload(:inputs)

    render(conn, "index.json-api", data: assoc.inputs)
  end

  def index(conn, _params) do
    inputs = Repo.all(Input)
    render(conn, "index.json-api", data: inputs)
  end

  def create(conn, %{"data" => data = %{"type" => "inputs", "attributes" => _input_params}}) do
    changeset = Input.changeset(%Input{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, input} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", api_v1_input_path(conn, :show, input))
        |> render("show.json-api", data: input)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    input = Repo.get!(Input, id)
    render(conn, "show.json-api", data: input)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "inputs", "attributes" => _input_params}}) do
    input = Repo.get!(Input, id)
    changeset = Input.changeset(input, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, input} ->
        render(conn, "show.json-api", data: input)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    input = Repo.get!(Input, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(input)

    send_resp(conn, :no_content, "")
  end

end
