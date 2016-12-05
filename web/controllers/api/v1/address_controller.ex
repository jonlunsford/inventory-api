defmodule Inventory.Api.V1.AddressController do
  use Inventory.Web, :controller

  alias Inventory.Address
  alias Inventory.Input
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, %{"company_id" => company_id}) do
    addresses = Address
      |> where(company_id: ^company_id)
      |> Repo.all

    render(conn, "index.json-api", data: addresses)
  end

  def index(conn, %{"input_id" => input_id}) do
    input =
      Repo.get(Input, input_id)
      |> Repo.preload(:address)

    render(conn, "index.json-api", data: input.address || [])
  end

  def index(conn, _params) do
    addresses = Repo.all(Address)
    render(conn, "index.json-api", data: addresses)
  end

  def create(conn, %{"data" => data = %{"type" => "addresses", "attributes" => _address_params}}) do
    changeset = Address.changeset(%Address{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, address} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", api_v1_address_path(conn, :show, address))
        |> render("show.json-api", data: address)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    address = Repo.get!(Address, id)
    render(conn, "show.json-api", data: address)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "addresses", "attributes" => _address_params}}) do
    address = Repo.get!(Address, id)
    changeset = Address.changeset(address, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, address} ->
        render(conn, "show.json-api", data: address)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    address = Repo.get!(Address, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(address)

    send_resp(conn, :no_content, "")
  end

end
