defmodule Inventory.Api.V1.ProductTest do
  use Inventory.ModelCase

  alias Inventory.Product

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Product.changeset(%Product{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Product.changeset(%Product{}, @invalid_attrs)
    refute changeset.valid?
  end

end

defmodule Inventory.ProductInsertTest do
  use ExUnit.Case
  use Inventory.ConnCase

  alias Inventory.Product
  alias Inventory.Category
  alias Inventory.ProductCategory
  alias Inventory.Repo

  setup do
    product = %Product{name: "Mac n Cheese"} |> Repo.insert!
    category = %Category{name: "Edibals"} |> Repo.insert!

    %ProductCategory{
      product_id: product.id,
      category_id: category.id
    } |> Repo.insert!

    { :ok, category_id: category.id, product_id: product.id  }
  end

  test "product added to category", context do
    product =
      Repo.get(Product, context[:product_id])
      |> Repo.preload(:categories)

    assert product.name == "Mac n Cheese"
    assert Enum.count(product.categories) == 1
  end

  test "category added to product", context do
    category =
      Repo.get(Category, context[:category_id])
      |> Repo.preload(:products)

    assert category.name == "Edibals"
    assert Enum.count(category.products) == 1
  end

end
