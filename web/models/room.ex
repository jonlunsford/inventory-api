defmodule Inventory.Room do
  use Inventory.Web, :model

  schema "rooms" do
    field :name, :string

    belongs_to :owner, Inventory.User
    has_one :participant, Inventory.User
    has_many :messages, Inventory.Message

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
