defmodule LiveViewStripe.BillingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LiveViewStripe.Billing` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        stripe_id: "some stripe_id",
        stripe_product_name: "some stripe_product_name"
      })
      |> LiveViewStripe.Billing.create_product()

    product
  end

  @doc """
  Generate a plan.
  """
  def plan_fixture(attrs \\ %{}) do
    {:ok, plan} =
      attrs
      |> Enum.into(%{
        amount: 42,
        stripe_id: "some stripe_id",
        stripe_plan_name: "some stripe_plan_name"
      })
      |> LiveViewStripe.Billing.create_plan()

    plan
  end

  @doc """
  Generate a customer.
  """
  def customer_fixture(attrs \\ %{}) do
    {:ok, customer} =
      attrs
      |> Enum.into(%{

      })
      |> LiveViewStripe.Billing.create_customer()

    customer
  end
end
