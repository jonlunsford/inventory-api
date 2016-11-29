defmodule Inventory.Address do
  use Inventory.Web, :model

  schema "addresses" do
    field :city, :string
    field :state, :string
    field :country, :string
    field :zip, :integer
    field :lat, :float
    field :long, :float
    field :line_1, :string
    field :line_2, :string
    field :phone, :string
    field :description, :string
    belongs_to :company, Inventory.Company
    belongs_to :input, Inventory.Input

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:city, :state, :country, :zip, :lat, :long, :line_1, :line_2, :phone, :description, :company_id, :input_id])
    |> validate_required([:city, :state, :zip])
  end
end
