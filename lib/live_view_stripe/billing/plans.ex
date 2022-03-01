defmodule LiveViewStripe.Billing.Plans do
  @moduledoc """
  The Billing Plans context.
  """

  import Ecto.Query, warn: false
  alias LiveViewStripe.Repo
  alias LiveViewStripe.Billing.Plan

  @doc """
  Returns the list of plans.

  ## Examples

      iex> list_plans()
      [%Plan{}, ...]

  """
  def list_plans do
    Repo.all(Plan)
  end

  @doc """
  Gets a single plan.

  Raises `Ecto.NoResultsError` if the Plan does not exist.

  ## Examples

      iex> get_plan!(123)
      %Plan{}

      iex> get_plan!(456)
      ** (Ecto.NoResultsError)

  """
  def get_plan!(id), do: Repo.get!(Plan, id)

  @doc """
  Gets a single plan by Stripe Id.

  Raises `Ecto.NoResultsError` if the Plan does not exist.

  ## Examples

      iex> get_plan_by_stripe_id!(123)
      %Plan{}

      iex> get_plan_by_stripe_id!(456)
      ** (Ecto.NoResultsError)

  """
  def get_plan_by_stripe_id!(stripe_id), do: Repo.get_by!(Plan, stripe_id: stripe_id)

  @doc """
  Creates a plan.

  ## Examples

      iex> create_plan(%{field: value})
      {:ok, %Plan{}}

      iex> create_plan(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_plan(product, attrs \\ %{}) do
    product
    |> Ecto.build_assoc(:plans)
    |> Plan.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a plan.

  ## Examples

      iex> update_plan(plan, %{field: new_value})
      {:ok, %Plan{}}

      iex> update_plan(plan, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_plan(%Plan{} = plan, attrs) do
    plan
    |> Plan.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a plan.

  ## Examples

      iex> delete_plan(plan)
      {:ok, %Plan{}}

      iex> delete_plan(plan)
      {:error, %Ecto.Changeset{}}

  """
  def delete_plan(%Plan{} = plan) do
    Repo.delete(plan)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking plan changes.

  ## Examples

      iex> change_plan(plan)
      %Ecto.Changeset{data: %Plan{}}

  """
  def change_plan(%Plan{} = plan, attrs \\ %{}) do
    Plan.changeset(plan, attrs)
  end

  @doc """
  Returns the list of plans with produt name.

  ## Examples

      iex> list_plans_for_subscription_page()
      [%Plan{}, ...]

  """
  def list_plans_for_subscription_page() do
    from(
      p in Plan,
      join: pp in assoc(p, :product),
      select: %{period: p.stripe_plan_name, name: pp.stripe_product_name, stripe_id: p.stripe_id, id: p.id, amount: p.amount},
      order_by: [p.amount, p.stripe_plan_name]
    )
    |> Repo.all()
  end
end
