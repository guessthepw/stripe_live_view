defmodule LiveViewStripe.BillingTest do
  use LiveViewStripe.DataCase

  alias LiveViewStripe.Billing

  describe "products" do
    setup [:setup_product]

    alias LiveViewStripe.Billing.Product

    @valid_attrs %{stripe_id: "some stripe_id", stripe_product_name: "some stripe_product_name"}
    @invalid_attrs %{stripe_id: nil, stripe_product_name: nil}
    @update_attrs %{
      stripe_id: "some updated stripe_id",
      stripe_product_name: "some updated stripe_product_name"
    }

    test "list_products/0 returns all products", context do
      assert Billing.list_products() == [context.product]
    end

    test "get_product!/1 returns the product with given id", context do
      product = context.product
      assert Billing.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
       new_attrs = %{
        stripe_id: "some new stripe_id",
        stripe_product_name: "some new stripe_product_name"
      }
      assert {:ok, %Product{} = product} = Billing.create_product(new_attrs)
      assert product.stripe_id == "some new stripe_id"
      assert product.stripe_product_name == "some new stripe_product_name"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Billing.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product", context do
      assert {:ok, %Product{} = product} = Billing.update_product(context.product, @update_attrs)
      assert product.stripe_id == "some updated stripe_id"
      assert product.stripe_product_name == "some updated stripe_product_name"
    end

    test "update_product/2 with invalid data returns error changeset", context do
      product = context.product
      assert {:error, %Ecto.Changeset{}} = Billing.update_product(product, @invalid_attrs)
      assert product == Billing.get_product!(product.id)
    end

    test "delete_product/1 deletes the product", context do
      product = context.product
      assert {:ok, %Product{}} = Billing.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset", context do
      assert %Ecto.Changeset{} = Billing.change_product(context.product)
    end

    def setup_product(attrs) do
      {:ok, product} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Billing.create_product()

      {:ok, product: product}
    end
  end

  describe "plans" do
    setup [:setup_plan]

    alias LiveViewStripe.Billing.Plan

    @valid_attrs %{
      amount: 42,
      stripe_id: "some plan stripe_id",
      stripe_plan_name: "some plan stripe_name"
    }

    @invalid_attrs %{amount: nil, stripe_id: nil, stripe_plan_name: nil}

    test "list_plans/0 returns all plans", context do
      assert Billing.list_plans() == [context.plan]
    end

    test "get_plan!/1 returns the plan with given id", context do
      assert Billing.get_plan!(context.plan.id) == context.plan
    end

    test "create_plan/1 with valid data creates a plan", context do
      new_attrs = %{
        amount: 42,
        stripe_id: "some new plan stripe_id",
        stripe_plan_name: "some new plan stripe_plan_name"
      }

      assert {:ok, %Plan{} = plan} = Billing.create_plan(context.product, new_attrs)

      assert plan.amount == 42
      assert plan.stripe_id == "some new plan stripe_id"
      assert plan.stripe_plan_name == "some new plan stripe_plan_name"
    end

    test "create_plan/1 with invalid data returns error changeset", context do
      assert {:error, %Ecto.Changeset{}} = Billing.create_plan(context.product, @invalid_attrs)
    end

    test "update_plan/2 with valid data updates the plan", context do
      plan = context.plan

      update_attrs = %{
        amount: 43,
        stripe_id: "some updated stripe_id",
        stripe_plan_name: "some updated stripe_plan_name"
      }

      assert {:ok, %Plan{} = plan} = Billing.update_plan(plan, update_attrs)
      assert plan.amount == 43
      assert plan.stripe_id == "some updated stripe_id"
      assert plan.stripe_plan_name == "some updated stripe_plan_name"
    end

    test "update_plan/2 with invalid data returns error changeset", context do
      plan = context.plan
      assert {:error, %Ecto.Changeset{}} = Billing.update_plan(plan, @invalid_attrs)
      assert plan == Billing.get_plan!(plan.id)
    end

    test "delete_plan/1 deletes the plan", context do
      plan = context.plan
      assert {:ok, %Plan{}} = Billing.delete_plan(plan)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_plan!(plan.id) end
    end

    test "change_plan/1 returns a plan changeset", context do
      assert %Ecto.Changeset{} = Billing.change_plan(context.plan)
    end

    def setup_plan(attrs) do
      {:ok, product} =
        attrs
        |> Enum.into(%{
          stripe_id: "start plan stripe_id",
          stripe_product_name: "start plan stripe_product_name"
        })
        |> Billing.create_product()

      {:ok, plan} = Billing.create_plan(product, @valid_attrs)

      {:ok, plan: plan, product: product}
    end
  end
end
