defmodule Inventory.Company do
  use Inventory.Web, :model

  schema "companies" do
    field :title, :string

    belongs_to :owner, Inventory.User
    has_many :categories, Inventory.Category

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
