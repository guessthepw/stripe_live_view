defmodule LiveViewStripe.Billing.HandleSubscriptions do
  @moduledoc """
  The module for handling stripe subscriptions.
  """
  alias LiveViewStripe.Billing.Plans
  alias LiveViewStripe.Billing.Customers
  alias LiveViewStripe.Billing.Subscriptions

  defdelegate get_customer_by_stripe_id!(customer_stripe_id), to: Customers
  defdelegate get_plan_by_stripe_id!(plan_stripe_id), to: Plans
  defdelegate get_subscription_by_stripe_id!(subscription_stripe_id), to: Subscriptions

  @doc """
  Creates a Stripe Subscription.
  """
  def create_subscription(%{customer: customer_stripe_id, plan: %{id: plan_stripe_id}} = stripe_subscription) do
    customer = get_customer_by_stripe_id!(customer_stripe_id)
    plan = get_plan_by_stripe_id!(plan_stripe_id)

    Subscriptions.create_subscription(plan, customer, %{
      stripe_id: stripe_subscription.id,
      status: stripe_subscription.status,
      current_period_end_at: unix_to_naive_datetime(stripe_subscription.current_period_end)
    })
  end

  @doc """
  Updates a Stripe Subscription.
  """
  def update_subscription(%{id: stripe_id} = stripe_subscription) do
    subscription = get_subscription_by_stripe_id!(stripe_id)
    cancel_at = stripe_subscription.cancel_at || stripe_subscription.canceled_at

    Subscriptions.update_subscription(subscription, %{status: stripe_subscription.status, cancel_at: unix_to_naive_datetime(cancel_at)})
  end

  # Convert unix to naive datetime.
  defp unix_to_naive_datetime(nil), do: nil

  defp unix_to_naive_datetime(datetime_in_seconds) do
    datetime_in_seconds
    |> DateTime.from_unix!()
    |> DateTime.to_naive()
  end
end
