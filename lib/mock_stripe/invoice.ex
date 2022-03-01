defmodule MockStripe.Invoice do
  alias MockStripe.Invoice

  defstruct [
    :currency,
    :period_start,
    :object,
    :total,
    :subscription,
    :customer_email,
    :payment_intent,
    :status,
    :amount_due,
    :period_end,
    :number,
    :customer,
    :id,
    :charge
  ]

  def retrieve() do
    stripe_id = "in_#{MockStripe.token()}"
    retrieve(stripe_id)
  end

  def retrieve("in_<> _" = stripe_id) do
    %Invoice{
      currency: "usd",
      period_start: 1_604_090_856,
      object: "invoice",
      total: 900,
      subscription: "sub_#{MockStripe.token()}",
      customer_email: "john@doe.com",
      payment_intent: "pi_#{MockStripe.token()}",
      status: "paid",
      amount_due: 900,
      period_end: 1_604_090_856,
      number: "829E84E4-0021",
      customer: "cus_#{MockStripe.token()}",
      id: stripe_id,
      charge: "ch_#{MockStripe.token()}"
    }
  end
end
