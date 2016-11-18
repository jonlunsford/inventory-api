defmodule Inventory.Message do
  use Inventory.Web, :model

  schema "messages" do
    field :content, :string
    belongs_to :owner, Inventory.User
    belongs_to :room, Inventory.Room

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content, :owner_id, :room_id])
    |> validate_required([:content])
  end
end
