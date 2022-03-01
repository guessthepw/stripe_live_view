defmodule LiveViewStripe.Billing.CreateStripeCustomer do
  @moduledoc """
  The module for creating a stripe customer.
  """
  use GenServer

  import Ecto.Query, warn: false
  alias LiveViewStripe.Repo
  alias LiveViewStripe.Billing.Customer

  @stripe_service Application.get_env(:live_view_stripe, :stripe_service)

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  @doc """
  Subscribe to new "user_created" messages on start.
  """
  def init(state) do
    LiveViewStripe.Accounts.subscribe_on_user_created()
    {:ok, state}
  end

  @doc """
  On creation of a local user, create a stripe customer and associate them. Then
  notify subscribers.
  """
  def handle_info(%{user: user}, state) do
    {:ok, %{id: stripe_id}} =
      @stripe_service.Customer.create(%{email: user.email})

    {:ok, billing_customer} =
      user
      |> Ecto.build_assoc(:billing_customer)
      |> Customer.changeset(%{stripe_id: stripe_id})
      |> Repo.insert()

    notify_subscribers(billing_customer)

    {:noreply, state}
  end

  def handle_info(_, state), do: {:noreply, state}

  @doc """
  Subscribe to further messages from "stripe_customer_created".
  """
  def subscribe do
    Phoenix.PubSub.subscribe(LiveViewStripe.PubSub, "stripe_customer_created")
  end

  @doc """
  Notify subscribers to "stripe_customer_created" and send the customer.
  """
  def notify_subscribers(customer) do
    Phoenix.PubSub.broadcast(
      LiveViewStripe.PubSub,
      "stripe_customer_created",
      {:customer, customer}
    )
  end

  defmodule Stub do
    @moduledoc """
    CreateStripeCustomer Stub for testing.
    """
    use GenServer
    def start_link(_), do: GenServer.start_link(__MODULE__, nil)
    def init(state), do: {:ok, state}
  end
end
