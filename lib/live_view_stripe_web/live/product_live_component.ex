defmodule LiveViewStripeWeb.LiveProductComponent do
  @moduledoc """
  LiveComponent module for the product pricing component.
  """
  use LiveViewStripeWeb, :live_component

  @doc """
  Adds the updated amount to assigns.
  """
  @impl true
  def update(assigns, socket) do
    amount =
      assigns.product.plans
      |> plan_price_for_interval(assigns.price_interval)
      |> format_price()

    socket =
      assign(socket, assigns)
      |> assign(:amount, amount)

    {:ok, socket}
  end

  @doc """
  Renders the heex for the product component.
  """
  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <p class="mb-1 text-xs font-semibold tracking-wide text-gray-500 uppercase">
        <%= @product.stripe_product_name %>
      </p>
      <h1 class="mb-2 text-5xl font-bold leading-tight text-gray-900 md:font-extrabold">
        <%= @amount %><span class="text-2xl font-medium text-gray-600"> per <%= @price_interval %></span>
      </h1>
      <p class="mb-6 text-lg text-gray-600">
        This plan comes with everything you would expect plus an online dashboard to manage your subscription.
        We may offer discounts, if you are worthy. Contact us for more information.
      </p>
      <div class="justify-center block md:flex space-x-0 md:space-x-2 space-y-2 md:space-y-0">
        <%= if @logged_in? do %>
          <%= live_redirect "Get Started",
                to: Routes.subscription_new_path(@socket, :new, %{interval: @price_interval, product: @product.stripe_product_name}),
                class: "w-full btn bg-red-500 w-full rounded text-white pl-3 pr-3 pt-2 pb-2 md:w-auto" %>
        <% else %>
          <%= live_redirect "Register", to: Routes.user_registration_path(@socket, :new),
                class: "w-full btn bg-red-500 w-full rounded text-white pl-3 pr-3 pt-2 pb-2 md:w-auto" %>
        <% end %>
      </div>
    </div>
    """
  end

  # Gets the price for a plan for a interval.
  defp plan_price_for_interval(plans, interval) do
    plans
    |> Enum.find(&(&1.stripe_plan_name == interval))
    |> Map.get(:amount)
  end

  # Gets a formatted string of an amount.
  defp format_price(amount), do: "$#{round(amount / 100)}"
end
