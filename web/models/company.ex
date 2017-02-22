defmodule Inventory.Company do
  use Inventory.Web, :model

  schema "companies" do
    field :title, :string

    belongs_to :owner, Inventory.User, on_replace: :delete
    has_many :categories, Inventory.Category, on_delete: :delete_all
    has_one :address, Inventory.Address, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end
end
