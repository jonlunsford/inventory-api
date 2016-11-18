defmodule Inventory.Category do
  use Inventory.Web, :model

  schema "categories" do
    field :name, :string
    belongs_to :company, Inventory.Company

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
