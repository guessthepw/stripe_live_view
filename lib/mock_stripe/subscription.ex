defmodule MockStripe.Subscription do
  alias MockStripe.Subscription

  defstruct [
    :latest_invoice,
    :cancel_at,
    :canceled_at,
    :status,
    :object,
    :id,
    :customer,
    :collection_method,
    :cancel_at_period_end
  ]

  def create(attrs \\ %{}) do
    {:ok,
     retrieve()
     |> Map.merge(attrs)}
  end

  def retrieve() do
    stripe_id = "sub_#{MockStripe.token()}"
    retrieve(stripe_id)
  end

  def retrieve("sub_" <> _ = stripe_id) do
    %Subscription{
      latest_invoice: "in_#{MockStripe.token()}",
      status: "active",
      object: "subscription",
      id: stripe_id,
      customer: "cus_#{MockStripe.token()}",
      collection_method: "charge_automatically",
      cancel_at_period_end: false
    }
  end
end
