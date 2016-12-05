defmodule Inventory.Address do
  use Inventory.Web, :model

  schema "addresses" do
    field :city, :string
    field :state, :string
    field :country, :string
    field :zip, :integer
    field :lat, :float
    field :long, :float
    field :line1, :string
    field :line2, :string
    field :phone, :string
    field :description, :string
    belongs_to :company, Inventory.Company
    has_one :input, Inventory.Input, on_delete: :delete_all

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:city, :state, :country, :zip, :lat, :long, :line1, :line2, :phone, :description, :company_id])
    |> validate_required([:city, :state, :zip])
  end
end
