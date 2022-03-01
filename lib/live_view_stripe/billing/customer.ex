defmodule LiveViewStripe.Billing.Customer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "billing_customers" do

    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [])
    |> validate_required([])
  end
end
