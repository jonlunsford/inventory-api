defmodule Inventory.Input do
  use Inventory.Web, :model

  schema "inputs" do
    field :name, :string
    field :label, :string
    field :value, :string
    field :disabled, :boolean, default: false
    field :meta, :map

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :label, :value, :disabled, :meta])
    |> validate_required([:name, :label, :value, :disabled, :meta])
  end
end
