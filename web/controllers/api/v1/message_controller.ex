defmodule Inventory.Api.V1.MessageController do
  use Inventory.Web, :controller

  alias Inventory.Message
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    messages = Repo.all(Message)
    render(conn, "index.json-api", data: messages)
  end

  def create(conn, %{"data" => data = %{"type" => "messages", "attributes" => _message_params}}) do
    params = Params.to_attributes(data)
    changeset =
      %Message{ owner_id: params["owner_id"], room_id: params["room_id"] }
      |> Message.changeset(params)

    case Repo.insert(changeset) do
      {:ok, message} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", api_v1_message_path(conn, :show, message))
        |> render("show.json-api", data: message)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    message = Repo.get!(Message, id)
    render(conn, "show.json-api", data: message)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "messages", "attributes" => _message_params}}) do
    message = Repo.get!(Message, id)
    changeset = Message.changeset(message, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, message} ->
        render(conn, "show.json-api", data: message)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Repo.get!(Message, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(message)

    send_resp(conn, :no_content, "")
  end

end
