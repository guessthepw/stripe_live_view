defmodule LiveViewStripe.Billing.Subscription do
  use Ecto.Schema
  import Ecto.Changeset

  schema "billing_subscriptions" do
    field(:cancel_at, :naive_datetime)
    field(:current_period_end_at, :naive_datetime)
    field(:status, :string)
    field(:stripe_id, :string)

    belongs_to(:plan, LiveViewStripe.Billing.Plan)
    belongs_to(:customer, LiveViewStripe.Billing.Customer)

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:stripe_id, :status, :current_period_end_at, :cancel_at])
    |> validate_required([:stripe_id, :status, :current_period_end_at])
    |> unique_constraint(:stripe_id, name: :billing_subscriptions_stripe_id_index)
  end
end
