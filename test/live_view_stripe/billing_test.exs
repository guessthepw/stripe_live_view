defmodule LiveViewStripe.BillingTest do
  use LiveViewStripe.DataCase

  alias LiveViewStripe.Billing

  describe "products" do
    alias LiveViewStripe.Billing.Product

    import LiveViewStripe.BillingFixtures

    @invalid_attrs %{stripe_id: nil, stripe_product_name: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Billing.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Billing.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{stripe_id: "some stripe_id", stripe_product_name: "some stripe_product_name"}

      assert {:ok, %Product{} = product} = Billing.create_product(valid_attrs)
      assert product.stripe_id == "some stripe_id"
      assert product.stripe_product_name == "some stripe_product_name"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Billing.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      update_attrs = %{stripe_id: "some updated stripe_id", stripe_product_name: "some updated stripe_product_name"}

      assert {:ok, %Product{} = product} = Billing.update_product(product, update_attrs)
      assert product.stripe_id == "some updated stripe_id"
      assert product.stripe_product_name == "some updated stripe_product_name"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Billing.update_product(product, @invalid_attrs)
      assert product == Billing.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Billing.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Billing.change_product(product)
    end
  end
end
