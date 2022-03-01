defmodule LiveViewStripeWeb.SubscriptionLive.New do
  @moduledoc """
  The LiveView module for creating a new subscription.
  """
  use LiveViewStripeWeb, :live_view
  import Ecto.Changeset

  alias LiveViewStripe.{Accounts, Billing}
  alias LiveViewStripe.Billing.{Customers, Plans}

  @stripe_service Application.get_env(:live_view_stripe, :stripe_service)

  @doc """
  We subscribe to notifications from the webbook processor, and add the user,
  user changeset, stripe customer, stripe plan id, stripe products, and utility
  variables to assigns.
  """
  @impl true
  def mount(_params, session, socket) do
    Billing.ProcessWebhook.subscribe()

    user = Accounts.get_user_by_session_token(session["user_token"])
    customer = Customers.get_billing_customer_for_user(user)
    products = get_products()
    initial_plan_id = get_initial_plan_id(products)

    {:ok, setup_intent} =
      Stripe.SetupIntent.create(%{customer: customer.stripe_id})

    socket =
      socket
      |> assign(:changeset, changeset(%{plan_id: initial_plan_id}))
      |> assign(:customer, customer)
      |> assign(:plan_id, initial_plan_id)
      |> assign(:products, products)
      |> assign(:error_message, nil)
      |> assign(:loading, false)
      |> assign(:retry, false)
      |> assign(:client_secret, setup_intent.client_secret)

    {:ok, socket}
  end

  @doc """
  Adds new plan_id and changeset to assigns.
  """
  @impl true
  def handle_event("update-plan", %{"price" => %{"plan_id" => plan_id}}, socket) do
    socket =
      socket
      |> assign(:plan_id, plan_id)
      |> assign(:changeset, changeset(%{plan_id: plan_id}))

    {:noreply, socket}
  end

  def handle_event("payment-confirmed", _params, socket) do
    {:noreply, redirect(socket, to: Routes.subscribers_home_path(socket, :index))}
  end

  @doc """
  Handle incoming events from the webbook processor.
  """
  @impl true
  def handle_info({:event, event}, socket) do
    event
    |> filter_event_for_current_customer(socket.assigns.customer)
    |> Map.get(:type)
    |> case do
      "payment_method.attached" ->
        if socket.assigns.retry do
          {:noreply, socket}
        else
          create_subscription(socket)
        end

      _ ->
        {:noreply, socket}
    end
  end

  # Create a subscription from the customer and plan id in assigns.
  defp create_subscription(socket) do
    %{customer: customer, plan_id: plan_id} = socket.assigns
    price_stripe_id = Plans.get_plan!(plan_id).stripe_id

    {:ok, subscription} =
      @stripe_service.Subscription.create(%{
        customer: customer.stripe_id,
        items: [%{price: price_stripe_id}]
      })

    socket =
      socket
      |> assign(%{subscription: subscription})

    {:noreply, socket}
  end

  # Filters events from the webbook processor for the stripe customer passed in.
  defp filter_event_for_current_customer(event, customer) do
    if Map.get(event.data.object, :customer) == customer.stripe_id do
      event
    else
      Map.put(event, :type, nil)
    end
  end

  defp changeset(attrs) do
    cast({%{}, %{stripe_id: :string}}, attrs, [:stripe_id])
  end

  # Gets the first plan id, given a list of stripe products.
  defp get_initial_plan_id(products) do
    case products do
      [{_, [{_, plan_id} | _]} | _] -> plan_id
      _ -> nil
    end
  end

  # List stripe subscriptions.
  defp get_products() do
    Plans.list_plans_for_subscription_page()
    |> Enum.group_by(&Map.get(&1, :period))
    |> Enum.reduce([], fn {period, plans}, acc ->
      plans = Enum.map(plans, fn plan -> {format_plan_name(plan), plan.id} end)
      period = String.capitalize("#{period}ly subscription")

      Enum.concat(acc, [{period, plans}])
    end)
  end

  # Format plan name for dropdown.
  defp format_plan_name(plan), do: "#{plan.name} - #{format_price(plan.amount)}"

  # Format plan price for dropdown
  defp format_price(amount) do
    rounded_amount = round(amount / 100)
    "$#{rounded_amount}"
  end
end
