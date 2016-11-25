defmodule Inventory.Api.V1.InputTest do
  use Inventory.ModelCase

  alias Inventory.Input

  @valid_attrs %{ disabled: true, label: "some content", meta: %{}, name: "some content", value: "some content", input_type: "text"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Input.changeset(%Input{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Input.changeset(%Input{}, @invalid_attrs)
    refute changeset.valid?
  end
end

defmodule Inventory.InputInsertTest do
  use ExUnit.Case
  use Inventory.ConnCase

  alias Inventory.Product
  alias Inventory.Category
  alias Inventory.Input
  alias Inventory.Repo

  setup do
    product = %Product{name: "Mac n Cheese"} |> Repo.insert!
    category = %Category{name: "My Category"} |> Repo.insert!
    input_a = %Input{name: "My Input", product_id: product.id} |> Repo.insert!
    input_b = %Input{name: "My Second Input", category_id: category.id} |> Repo.insert!

    { :ok,
      input_a_id: input_a.id,
      input_b_id: input_b.id,
      product_id: product.id,
      category_id: category.id
    }
  end

  test "input added to product", context do
    input =
      Repo.get(Input, context[:input_a_id])
      |> Repo.preload(:product)

    assert input.name == "My Input"
    assert input.product.name == "Mac n Cheese"
  end

  test "input added to category", context do
    input =
      Repo.get(Input, context[:input_b_id])
      |> Repo.preload(:category)

    assert input.name == "My Second Input"
    assert input.category.name == "My Category"
  end

end
