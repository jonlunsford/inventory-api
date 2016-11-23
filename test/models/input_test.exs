defmodule Inventory.Api.V1.InputTest do
  use Inventory.ModelCase

  alias Inventory.Input

  @valid_attrs %{ disabled: true, label: "some content", meta: %{}, name: "some content", value: "some content"}
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
  alias Inventory.ProductInput
  alias Inventory.CategoryInput
  alias Inventory.Repo

  setup do
    product = %Product{name: "Mac n Cheese"} |> Repo.insert!
    input = %Input{name: "beer_name"} |> Repo.insert!
    category = %Category{name: "My Category"} |> Repo.insert!

    %CategoryInput{
      category_id: category.id,
      input_id: input.id
    } |> Repo.insert!

    %ProductInput{
      product_id: product.id,
      input_id: input.id
    } |> Repo.insert!

    { :ok, input_id: input.id, product_id: product.id, category_id: category.id  }
  end

  test "product added to input", context do
    product =
      Repo.get(Product, context[:product_id])
      |> Repo.preload(:inputs)

    assert product.name == "Mac n Cheese"
    assert Enum.count(product.inputs) == 1
  end

  test "input added to product", context do
    input =
      Repo.get(Input, context[:input_id])
      |> Repo.preload(:products)

    assert input.name == "beer_name"
    assert Enum.count(input.products) == 1
  end

  test "input added to category", context do
    input =
      Repo.get(Input, context[:input_id])
      |> Repo.preload(:categories)

    assert input.name == "beer_name"
    assert Enum.count(input.categories) == 1
  end

end
