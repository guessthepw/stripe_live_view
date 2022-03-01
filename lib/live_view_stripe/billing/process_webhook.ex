defmodule LiveViewStripe.Billing.ProcessWebhook do
  @moduledoc """
  The module for processing webhook event data.
  """
  use GenServer

  alias LiveViewStripeWeb.StripeWebhookController
  alias LiveViewStripe.Billing.SyncProducts
  alias LiveViewStripe.Billing.HandleSubscriptions
  # alias LiveViewStripe.Billing.SyncPlans

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  @doc """
  Subscribe to new webhook messages on start.
  """
  def init(state) do
    StripeWebhookController.subscribe_on_webhook_recieved()
    {:ok, state}
  end

  @doc """
  Notify subscribers that an event has been processed.

  If it is a product related event, we sync products. If it s a plan related event,
  we sync plans or if it is a subscription related event we use the HandleSubscriptions
  module.
  """
  def handle_info(%{event: event}, state) do
    notify_subscribers(event)

    case event.type do
      "product.created" -> SyncProducts.run()
      "product.updated" -> SyncProducts.run()
      "product.deleted" -> SyncProducts.run()
      # "plan.created" -> SyncPlans.run()
      # "plan.updated" -> SyncPlans.run()
      # "plan.deleted" -> SyncPlans.run()
      "customer.updated" -> nil
      "customer.deleted" -> nil
      "customer.subscription.updated" -> HandleSubscriptions.update_subscription(event.data.object)
      "customer.subscription.deleted" -> HandleSubscriptions.update_subscription(event.data.object)
      "customer.subscription.created" -> HandleSubscriptions.create_subscription(event.data.object)
      _ -> nil
    end

    {:noreply, state}
  end

  @doc """
  Subscribe to further messages from "webhook_processed".
  """
  def subscribe do
    Phoenix.PubSub.subscribe(LiveViewStripe.PubSub, "webhook_processed")
  end

  @doc """
  Notify subscribers to "webhook_processed" that a webhook has been processed and
  send the event.
  """
  def notify_subscribers(event) do
    Phoenix.PubSub.broadcast(LiveViewStripe.PubSub, "webhook_processed", {:event, event})
  end

  defmodule Stub do
    @moduledoc """
    Webbook Stub for testing.
    """
    use GenServer
    def start_link(_), do: GenServer.start_link(__MODULE__, nil)
    def init(state), do: {:ok, state}
  end
end
