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
end
