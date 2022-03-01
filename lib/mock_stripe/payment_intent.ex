defmodule MockStripe.PaymentIntent do
  alias MockStripe.PaymentIntent

  defstruct [
    :payment_method,
    :payment_method_types,
    :amount,
    :client_secret,
    :status,
    :object,
    :invoice,
    :amount_received,
    :id,
    :customer
  ]

  def retrieve() do
    stripe_id = "pi_#{MockStripe.token()}"
    retrieve(stripe_id, %{})
  end

  def retrieve("pi_" <> _ = stripe_id, _opts) do
    %PaymentIntent{
      payment_method: "pm_#{MockStripe.token()}",
      payment_method_types: ["card"],
      amount: 900,
      client_secret: "pi_#{MockStripe.token()}_secret_#{MockStripe.token()}",
      status: "succeeded",
      object: "payment_intent",
      invoice: "in_#{MockStripe.token()}",
      amount_received: 900,
      id: stripe_id,
      customer: "cus_#{MockStripe.token()}"
    }
  end
end
