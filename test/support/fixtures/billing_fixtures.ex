defmodule LiveViewStripe.BillingFixtures do
@moduledoc """
  This module defines test helpers for creating
  entities via the `LiveViewStripe.Billing` context.
  """

  import LiveViewStripe.AccountsFixtures

  alias LiveViewStripe.Billing.{Products, Plans, Customers, Subscriptions}
  alias LiveViewStripe.Accounts.User

  def unique_stripe_id, do: "foo_#{System.unique_integer()}"

  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{stripe_id: "some stripe_id", stripe_product_name: "some stripe_product_name"})
      |> Products.create_product()

    product
  end

  def customer_fixture(), do: customer_fixture(%{})
  def customer_fixture(%User{} = user), do: customer_fixture(user, %{})

  def customer_fixture(attrs) do
    user = user_fixture()
    customer_fixture(user, attrs)
  end

  def customer_fixture(%User{} = user, attrs) do
    attrs =
      Enum.into(attrs, %{default_source: "some default_source", stripe_id: "some stripe_id"})

    {:ok, customer} = Customers.create_customer(user, attrs)

    customer
  end

  def plan_fixture(attrs \\ %{}) do
    product = product_fixture()

    attrs =
      Enum.into(attrs, %{
        amount: 42,
        stripe_id: "some stripe_id",
        stripe_plan_name: "some stripe_plan_name"
      })

    {:ok, plan} = Plans.create_plan(product, attrs)

    plan
  end

  def active_subscription_fixture(user) do
    plan = plan_fixture()
    customer = customer_fixture(user)
    attrs = %{stripe_id: unique_stripe_id(), status: "active", cancel_at: nil, current_period_end_at: ~N[2030-04-17 14:00:00]}

    subscription_fixture(plan, customer, attrs)
  end

  def inactive_subscription_fixture(user) do
    plan = plan_fixture()
    customer = customer_fixture(user)
    attrs = %{stripe_id: unique_stripe_id(), status: "active", cancel_at: nil, current_period_end_at: ~N[2010-04-17 14:00:00]}

    subscription_fixture(plan, customer, attrs)
  end

  def canceled_subscription_fixture(user) do
    plan = plan_fixture()
    customer = customer_fixture(user)
    attrs = %{stripe_id: unique_stripe_id(), status: "cancelled", cancel_at: ~N[2010-04-17 14:00:00], current_period_end_at: ~N[2030-04-17 14:00:00]}

    subscription_fixture(plan, customer, attrs)
  end

  def subscription_fixture(), do: subscription_fixture(%{})

  def subscription_fixture(attrs) do
    plan = plan_fixture()
    customer = customer_fixture()

    subscription_fixture(plan, customer, attrs)
  end

  def subscription_fixture(plan, customer, attrs) do
    attrs =
      Enum.into(attrs, %{
        cancel_at: ~N[2010-04-17 14:00:00],
        current_period_end_at: ~N[2010-04-17 14:00:00],
        status: "some status",
        stripe_id: "some stripe_id"
      })

    {:ok, subscription} = Subscriptions.create_subscription(plan, customer, attrs)

    Subscriptions.get_subscription!(subscription.id)
  end

end
