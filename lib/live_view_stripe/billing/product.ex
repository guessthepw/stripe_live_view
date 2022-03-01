defmodule LiveViewStripe.Billing.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "billing_products" do
    field :stripe_id, :string
    field :stripe_product_name, :string

    has_many(:plans, LiveViewStripe.Billing.Plan, foreign_key: :billing_product_id)

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:stripe_id, :stripe_product_name])
    |> validate_required([:stripe_id, :stripe_product_name])
    |> unique_constraint(:stripe_id, name: :billing_products_stripe_id_index)
  end
end
