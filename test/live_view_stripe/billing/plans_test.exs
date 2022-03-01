defmodule LiveViewStripe.Billing.PlansTest do
  use LiveViewStripe.DataCase

  import LiveViewStripe.BillingFixtures

  alias LiveViewStripe.Billing.Plans
  alias LiveViewStripe.Billing.Plan

  describe "plans" do
    test "list_plans/0 returns all plans" do
      plan = plan_fixture()
      assert Plans.list_plans() == [plan]
    end

    test "list_plans_for_subscription_page/0 returns all plans" do
      plan_fixture()

      assert [%{amount: 42, name: "some stripe_product_name", period: "some stripe_plan_name"}] =
               Plans.list_plans_for_subscription_page()
    end

    test "get_plan!/1 returns the plan with given id" do
      plan = plan_fixture()
      assert Plans.get_plan!(plan.id) == plan
    end

    test "get_plan_by_stripe_id!/1 returns the plan with given stripe_id" do
      plan = plan_fixture()
      assert Plans.get_plan_by_stripe_id!(plan.stripe_id) == plan
    end

    test "create_plan/1 with valid data creates a plan" do
      product = product_fixture()

      assert {:ok, %Plan{} = plan} =
               Plans.create_plan(product, %{
                 amount: 42,
                 stripe_id: "some stripe_id",
                 stripe_plan_name: "some stripe_plan_name"
               })

      assert plan.amount == 42
      assert plan.stripe_id == "some stripe_id"
      assert plan.stripe_plan_name == "some stripe_plan_name"
    end

    test "create_plan/1 with invalid data returns error changeset" do
      product = product_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Plans.create_plan(product, %{amount: nil, stripe_id: nil, stripe_plan_name: nil})
    end

    test "update_plan/2 with valid data updates the plan" do
      plan = plan_fixture()

      assert {:ok, %Plan{} = plan} =
               Plans.update_plan(plan, %{
                 amount: 43,
                 stripe_id: "some updated stripe_id",
                 stripe_plan_name: "some updated stripe_plan_name"
               })

      assert plan.amount == 43
      assert plan.stripe_id == "some updated stripe_id"
      assert plan.stripe_plan_name == "some updated stripe_plan_name"
    end

    test "update_plan/2 with invalid data returns error changeset" do
      plan = plan_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Plans.update_plan(plan, %{amount: nil, stripe_id: nil, stripe_plan_name: nil})

      assert plan == Plans.get_plan!(plan.id)
    end

    test "delete_plan/1 deletes the plan" do
      plan = plan_fixture()
      assert {:ok, %Plan{}} = Plans.delete_plan(plan)
      assert_raise Ecto.NoResultsError, fn -> Plans.get_plan!(plan.id) end
    end

    test "change_plan/1 returns a plan changeset" do
      plan = plan_fixture()
      assert %Ecto.Changeset{} = Plans.change_plan(plan)
    end
  end
end
