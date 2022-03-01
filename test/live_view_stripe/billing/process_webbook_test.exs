defmodule LiveViewStripe.Billing.ProcessWebhookTest do
  use LiveViewStripe.DataCase

  @stripe_service Application.get_env(:live_view_stripe, :stripe_service)

  alias LiveViewStripe.Billing.ProcessWebhook
  alias LiveViewStripeWeb.StripeWebhookController

  def event_fixture(attrs \\ %{}) do
    @stripe_service.Event.generate(attrs)
  end

  describe "listen for and processing a stripe event" do
    test "processes incoming events after broadcasing it" do
      start_supervised(ProcessWebhook, [])
      ProcessWebhook.subscribe()

      event = event_fixture()
      StripeWebhookController.notify_subscribers(event)

      assert_receive {:event, _}
    end
  end
end
