defmodule LiveViewStripe.Billing.SubscriptionsTest do
  use LiveViewStripe.DataCase

  import LiveViewStripe.BillingFixtures
  # import LiveViewStripe.AccountsFixtures

  alias LiveViewStripe.Billing.Subscriptions
  alias LiveViewStripe.Billing.Subscription

  describe "subscriptions" do
    test "list_subscriptions/0 returns all subscriptions" do
      subscription = subscription_fixture()
      assert Subscriptions.list_subscriptions() == [subscription]
    end

    test "get_subscription!/1 returns the subscription with given id" do
      subscription = subscription_fixture()
      assert Subscriptions.get_subscription!(subscription.id) == subscription
    end

    test "get_subscription_by_stripe_id!/1 returns the subscription with given stripe_id" do
      subscription = subscription_fixture()
      assert Subscriptions.get_subscription_by_stripe_id!(subscription.stripe_id) == subscription
    end

    # test "get_active_subscription_for_user/1 with active subscription returns the subscription for given user" do
    #   user = user_fixture()
    #   %{id: id} = active_subscription_fixture(user)

    #   assert %Subscription{id: ^id} = Subscriptions.get_active_subscription_for_user(user.id)
    # end

    # test "get_active_subscription_for_user/1 with inactive subscription returns nil for given user" do
    #   user = user_fixture()

    #   assert %{id: _id} = inactive_subscription_fixture(user)
    #   assert Subscriptions.get_active_subscription_for_user(user.id) == nil
    # end

    # test "get_active_subscription_for_user/1 with canceled subscription returns nil for given user" do
    #   user = user_fixture()

    #   assert %{id: _id} = canceled_subscription_fixture(user)
    #   assert Subscriptions.get_active_subscription_for_user(user.id) == nil
    # end

    test "create_subscription/1 with valid data creates a subscription" do
      plan = plan_fixture()
      customer = customer_fixture()

      create_attrs = %{cancel_at: ~N[2010-04-17 14:00:00], current_period_end_at: ~N[2010-04-17 14:00:00], status: "some status", stripe_id: "some stripe_id"}
      assert {:ok, %Subscription{} = subscription} = Subscriptions.create_subscription(plan, customer, create_attrs)
      assert subscription.cancel_at == ~N[2010-04-17 14:00:00]
      assert subscription.current_period_end_at == ~N[2010-04-17 14:00:00]
      assert subscription.status == "some status"
      assert subscription.stripe_id == "some stripe_id"
    end

    test "create_subscription/1 with invalid data returns error changeset" do
      plan = plan_fixture()
      customer = customer_fixture()

      assert {:error, %Ecto.Changeset{}} = Subscriptions.create_subscription(plan, customer, %{status: nil, stripe_id: nil})
    end

    test "update_subscription/2 with valid data updates the subscription" do
      subscription = subscription_fixture()
      update_attrs = %{cancel_at: ~N[2011-05-18 15:01:01], current_period_end_at: ~N[2011-05-18 15:01:01], status: "some updated status", stripe_id: "some updated stripe_id"}
      assert {:ok, %Subscription{} = subscription} = Subscriptions.update_subscription(subscription, update_attrs)
      assert subscription.cancel_at == ~N[2011-05-18 15:01:01]
      assert subscription.current_period_end_at == ~N[2011-05-18 15:01:01]
      assert subscription.status == "some updated status"
      assert subscription.stripe_id == "some updated stripe_id"
    end

    test "update_subscription/2 with invalid data returns error changeset" do
      subscription = subscription_fixture()
      assert {:error, %Ecto.Changeset{}} = Subscriptions.update_subscription(subscription, %{status: nil, stripe_id: nil})
      assert subscription == Subscriptions.get_subscription!(subscription.id)
    end

    test "delete_subscription/1 deletes the subscription" do
      subscription = subscription_fixture()
      assert {:ok, %Subscription{}} = Subscriptions.delete_subscription(subscription)
      assert_raise Ecto.NoResultsError, fn -> Subscriptions.get_subscription!(subscription.id) end
    end

    test "change_subscription/1 returns a subscription changeset" do
      subscription = subscription_fixture()
      assert %Ecto.Changeset{} = Subscriptions.change_subscription(subscription)
    end
  end
end
