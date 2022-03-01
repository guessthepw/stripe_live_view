defmodule MockStripe.Customer do
  defstruct [
    :created,
    :default_source,
    :email,
    :id,
    :name,
    :object
  ]

  alias MockStripe.List
  alias MockStripe.Customer

  def create(attrs \\ %{}) do
    {:ok,
     retrieve()
     |> Map.merge(attrs)}
  end

  def retrieve() do
    stripe_id = "cus_#{MockStripe.token()}"
    retrieve(stripe_id)
  end

  def retrieve("cus_" <> _ = stripe_id) do
    %Customer{
      created: 1_600_892_385,
      email: "john@herbener.cloud",
      id: stripe_id,
      name: "John Herbener",
      object: "customer"
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
       url: "/v1/customers"
     }}
  end

  def update(customer_stripe_id, attrs) do
    {:ok,
     retrieve()
     |> Map.merge(%{id: customer_stripe_id})
     |> Map.merge(attrs)}
  end
end
