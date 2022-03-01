defmodule LiveViewStripe.Billing.HandleSubscriptionsTest do
  use LiveViewStripe.DataCase

  import LiveViewStripe.BillingFixtures

  alias LiveViewStripe.Billing.Subscription
  alias LiveViewStripe.Billing.Subscriptions
  alias LiveViewStripe.Billing.HandleSubscriptions

  describe "create_subscription" do
    setup [:setup_customer, :setup_plan]

    test "create_subscription/1 creates a subscription", %{customer: customer, plan: plan} do
      %{id: stripe_id} =
        stripe_subscription =
        subscription_data(%{customer: customer.stripe_id, plan: %Stripe.Plan{id: plan.stripe_id}})

      HandleSubscriptions.create_subscription(stripe_subscription)

      assert [%Subscription{stripe_id: ^stripe_id} = subscription] = Subscriptions.list_subscriptions()
      assert subscription.status == "active"
      assert subscription.current_period_end_at == ~N[2020-11-30 11:35:29]
      assert subscription.customer_id == customer.id
      assert subscription.plan_id == plan.id
    end
  end

  describe "update subscription" do
    setup [:setup_subscription]

    test "update_subscription/1 cancels a subscription", %{subscription: subscription} do
      stripe_subscription =
        subscription_data(%{
          id: subscription.stripe_id,
          status: "canceled",
          canceled_at: 1_604_064_386
        })

      assert [%Subscription{cancel_at: nil}] = Subscriptions.list_subscriptions()
      HandleSubscriptions.update_subscription(stripe_subscription)

      assert [%Subscription{status: "canceled", cancel_at: ~N[2020-10-30 13:26:26]}] =
               Subscriptions.list_subscriptions()
    end
  end

  defp setup_customer(_) do
    customer = customer_fixture(%{stripe_id: unique_stripe_id()})
    %{customer: customer}
  end

  defp setup_plan(_) do
    plan = plan_fixture(%{stripe_id: unique_stripe_id()})
    %{plan: plan}
  end

  defp setup_subscription(_) do
    subscription = subscription_fixture(%{status: "active", cancel_at: nil})
    %{subscription: subscription}
  end

  defp subscription_data(attrs) do
    %Stripe.Subscription{
      created: 1_604_057_729,
      current_period_start: 1_604_057_729,
      start_date: 1_604_057_729,
      billing_cycle_anchor: 1_604_057_729,
      current_period_end: 1_606_736_129,
      object: "subscription",
      id: unique_stripe_id(),
      latest_invoice: unique_stripe_id(),
      customer: unique_stripe_id(),
      quantity: 1,
      status: "active",
      collection_method: "charge_automatically",
      cancel_at_period_end: false,
      plan: %Stripe.Plan{
        id: unique_stripe_id()
      }
    }
    |> Map.merge(attrs)
  end
end
