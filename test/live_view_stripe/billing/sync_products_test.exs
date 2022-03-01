defmodule LiveViewStripe.Billing.SynchronizeProductsTest do
  use LiveViewStripe.DataCase

  alias LiveViewStripe.Billing.Products
  alias LiveViewStripe.Billing.SyncProducts

  describe "run" do
    test "run/0 syncs products from stripe and creates them in billing_products" do
      assert Products.list_products() == []

      SyncProducts.run()
      assert [%LiveViewStripe.Billing.Product{} | _] = Products.list_products()
    end

    test "run/0 deletes products that exists in local database but does not exists in stripe" do
      {:ok, product} =
        Products.create_product(%{
          stripe_product_name: "Dont exists",
          stripe_id: "prod_abc123def456"
        })

      assert Products.list_products() == [product]

      SyncProducts.run()
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end
  end
end
