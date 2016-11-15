defmodule Inventory.GuardianSerializer do
  @behaviour Guardian.Serializer

  alias Inventory.Repo
  alias Inventory.User

  def for_token(user = %User{}), do: { :ok, "User:#{user.id}" }
  def for_token(_), do: { :error, "Unknown resource type" }

  def from_token("User:" <> id), do: { :ok, Repo.get(User, id) }
  def frim_token(_), do: { :error, "Unknown resource type" }
end