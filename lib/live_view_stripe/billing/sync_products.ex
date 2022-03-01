defmodule LiveViewStripe.Billing.SyncProducts do
  @moduledoc """
  The module for syncing products between the postgres database and Stripe.
  """
  alias LiveViewStripe.Billing.Products

  @stripe_service Application.get_env(:live_view_stripe, :stripe_service)

  # Gets all active plans from stripe.
  defp get_all_active_products_from_stripe do
    {:ok, %{data: products}} = @stripe_service.Product.list(%{active: true})
    products
  end

  @doc """
  Compare products stored in database with what is listed on Stripe.

  If a product doesn't exist then we create it, if a product has changed we
  update our local record, if a product was deleted, we delete our local record.
  """
  def run do
    # First, we gather our existing products
    products_by_stripe_id =
      Products.list_products()
      |> Enum.group_by(& &1.stripe_id)

    existing_stripe_ids =
      get_all_active_products_from_stripe()
      |> Enum.map(fn stripe_product ->
        case Map.get(products_by_stripe_id, stripe_product.id) do
          nil ->
            Products.create_product(%{
              stripe_id: stripe_product.id,
              stripe_product_name: stripe_product.name
            })

          [billing_product] ->
            Products.update_product(billing_product, %{stripe_product_name: stripe_product.name})
        end

        stripe_product.id
      end)

    products_by_stripe_id
    |> Enum.reject(fn {stripe_id, _billing_product} ->
      Enum.member?(existing_stripe_ids, stripe_id)
    end)
    |> Enum.each(fn {_stripe_id, [billing_product]} ->
      Products.delete_product(billing_product)
    end)
  end
end
