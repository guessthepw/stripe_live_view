defmodule LiveViewStripe.Billing.Subscriptions do
  @moduledoc """
  The Billing Subscriptions context.
  """

  import Ecto.Query, warn: false
  alias LiveViewStripe.Repo
  alias LiveViewStripe.Billing.Subscription

  @doc """
  Returns the list of subscriptions.

  ## Examples

      iex> list_subscriptions()
      [%Subscription{}, ...]

  """
  def list_subscriptions do
    Repo.all(Subscription)
  end

  @doc """
  Gets a single subscription.

  Raises `Ecto.NoResultsError` if the Subscription does not exist.

  ## Examples

      iex> get_subscription!(123)
      %Subscription{}

      iex> get_subscription!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subscription!(id), do: Repo.get!(Subscription, id)

  @doc """
  Gets a single subscription by Stripe Id.

  Raises `Ecto.NoResultsError` if the Subscription does not exist.

  ## Examples

      iex> get_subscription_by_stripe_id!(123)
      %Subscription{}

      iex> get_subscription_by_stripe_id!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subscription_by_stripe_id!(stripe_id), do: Repo.get_by!(Subscription, stripe_id: stripe_id)

  @doc """
  Gets a single active subscription for a user_id.

  Returns `nil` if an active Subscription does not exist.

  ## Examples

      iex> get_active_subscription_for_user(123)
      %Subscription{}

      iex> get_active_subscription_for_user(456)
      nil

  """
  def get_active_subscription_for_user(user_id) do
    from(s in Subscription,
      join: c in assoc(s, :customer),
      where: c.user_id == ^user_id,
      where: is_nil(s.cancel_at) or s.cancel_at > ^NaiveDateTime.utc_now(),
      where: s.current_period_end_at > ^NaiveDateTime.utc_now(),
      where: s.status == "active",
      limit: 1
    )
    |> Repo.one()
  end

  @doc """
  Creates a subscription.

  ## Examples

      iex> create_subscription(%{field: value})
      {:ok, %Subscription{}}

      iex> create_subscription(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subscription(plan, customer, attrs \\ %{}) do
    plan
    |> Ecto.build_assoc(:subscriptions)
    |> Subscription.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:customer, customer)
    |> Repo.insert()
  end

  @doc """
  Updates a subscription.

  ## Examples

      iex> update_subscription(subscription, %{field: new_value})
      {:ok, %Subscription{}}

      iex> update_subscription(subscription, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subscription(%Subscription{} = subscription, attrs) do
    subscription
    |> Subscription.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a subscription.

  ## Examples

      iex> delete_subscription(subscription)
      {:ok, %Subscription{}}

      iex> delete_subscription(subscription)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subscription(%Subscription{} = subscription) do
    Repo.delete(subscription)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subscription changes.

  ## Examples

      iex> change_subscription(subscription)
      %Ecto.Changeset{data: %Subscription{}}

  """
  def change_subscription(%Subscription{} = subscription, attrs \\ %{}) do
    Subscription.changeset(subscription, attrs)
  end
end
