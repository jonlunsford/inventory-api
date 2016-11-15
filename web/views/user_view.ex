defmodule Inventory.UserView do
  use Inventory.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Inventory.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Inventory.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      "type": "user",
      "id": user.id,
      "attributes": %{
        "email": user.email
      }
    }
  end
end
