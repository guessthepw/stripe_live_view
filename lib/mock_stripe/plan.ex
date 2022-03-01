defmodule MockStripe.Plan do
  defstruct [
    :active,
    :amount,
    :amount_decimal,
    :currency,
    :deleted,
    :id,
    :interval,
    :interval_count,
    :name,
    :nickname,
    :object,
    :product,
    :usage_type
  ]

  alias MockStripe.List
  alias MockStripe.Plan

  def retrieve() do
    stripe_id = "price_#{MockStripe.token()}"
    retrieve(stripe_id)
  end

  def retrieve("price_" <> _ = stripe_id) do
    %Plan{
      active: true,
      amount: 9900,
      amount_decimal: "9900",
      currency: "usd",
      id: stripe_id,
      interval: "year",
      interval_count: 1,
      nickname: "One year membership",
      object: "plan",
      product: "prod_I2TE8siyANz84p",
      usage_type: "licensed"
    }
  end

  def list(_attrs \\ %{}) do
    {:ok,
     %List{
       data: [
         retrieve()
       ],
       has_more: false,
       object: "list",
       total_count: nil,
       url: "/v1/plans"
     }}
  end
end
