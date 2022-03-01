defmodule LiveViewStripeWeb.SubscribersLive.Home do
  @moduledoc """
  The module to handle the members only Hhme LiveView.
  """
  use LiveViewStripeWeb, :live_view

  alias LiveViewStripe.Accounts
  alias LiveViewStripe.Billing.Customers

  @doc """
  Add Stripe customer to assigns on mount.
  """
  @impl true
  def mount(_params, session, socket) do
    customer =
      Accounts.get_user_by_session_token(session["user_token"])
      |> Customers.get_billing_customer_for_user()

    socket =
      socket
      |> assign(:customer, customer)

    {:ok, socket}
  end
end
