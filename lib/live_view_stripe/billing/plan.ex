defmodule LiveViewStripe.Billing.Plan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "billing_plans" do
    field :amount, :integer
    field :stripe_id, :string
    field :stripe_plan_name, :string
    belongs_to :product, LiveviewStripe.Billing.Product, foreign_key: :billing_product_id
    timestamps()
  end

  @doc false
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [:stripe_id, :stripe_plan_name, :amount])
    |> validate_required([:stripe_id, :stripe_plan_name, :amount])
    |> unique_constraint(:stripe_id, name: :billing_plans_stripe_id_index)
  end
end
