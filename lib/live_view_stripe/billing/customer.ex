defmodule LiveViewStripe.Billing.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "billing_customers" do
    field(:stripe_id, :string)

    belongs_to(:user, LiveViewStripe.Accounts.User)
    has_many(:subscriptions, LiveViewStripe.Billing.Subscription)

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:stripe_id])
    |> validate_required([])
    |> unique_constraint(:stripe_id, name: :billing_customers_stripe_id_index)
  end
end
