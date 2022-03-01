defmodule LiveViewStripe.Billing.CreateStripeCustomerTest do
  use LiveViewStripe.DataCase
  import LiveViewStripe.AccountsFixtures

  alias LiveViewStripe.Accounts
  alias LiveViewStripe.Billing.Customers
  alias LiveViewStripe.Billing.CreateStripeCustomer

  describe "creating a stripe customer and billing customer" do
    test "creates a billing customer after broadcasting it" do
      %{id: id} = user = user_fixture()
      start_supervised(CreateStripeCustomer, [])
      CreateStripeCustomer.subscribe()

      Accounts.notify_subscribers({:ok, user})

      assert_receive {:customer, _}, 5000
      assert [%{user_id: ^id, stripe_id: "" <> _}] = Customers.list_customers()
    end
  end
end
