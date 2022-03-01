defmodule LiveViewStripeWeb.PricingLive.Page do
  @moduledoc """
  The LiveView module for handling the pricing plan page.
  """
  use LiveViewStripeWeb, :live_view

  alias LiveViewStripe.Billing.Products
  alias LiveViewStripeWeb.LiveProductComponent

  @doc """
  Adds a `logged_in?` key, Stripe products and price interval to assigns.
  """
  @impl true
  def mount(_params, session, socket) do
    logged_in? =
      Map.has_key?(session, "user_token")

    socket =
      socket
      |> assign(:products, get_products())
      |> assign(:price_interval, "month")
      |> assign(:logged_in?, logged_in?)

    {:ok, socket}
  end

  @doc """
  Handles event from the toggle on the front end to set the price interval.
  """
  @impl true
  def handle_event("set-interval", %{"interval" => price_interval}, socket) do
    {:noreply, assign(socket, :price_interval, price_interval)}
  end

  # List products sorted by cheapest plan price.
  defp get_products() do
    Products.list_products()
    |> Products.with_plans()
    |> Enum.sort_by(&cheapest_plan_price/1)
  end

  # Gets the cheapest price from a list of products.
  defp cheapest_plan_price(product) do
    product.plans
    |> Enum.map(& &1.amount)
    |> Enum.min()
  end
end
