defmodule LiveViewStripe.Billing.Products do
  @moduledoc """
  The Billing Products context.
  """

  import Ecto.Query, warn: false
  alias LiveViewStripe.Repo

  alias LiveViewStripe.Billing.Product

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Gets a single product by stripe_id.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product_by_stripe_id!("prod_IBuHQ")
      %Product{}

      iex> get_product!("prod_xxx")
      ** (Ecto.NoResultsError)

  """
  def get_product_by_stripe_id!(stripe_id), do: Repo.get_by!(Product, stripe_id: stripe_id)

  @doc """
  Preload plans for a product or a list of products.

  ## Examples

      iex> with_plans(%Product{})
      %Product{plans: [%Plan{}]}

  """
  def with_plans(product_or_products) do
    product_or_products
    |> Repo.preload(:plans)
  end

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end
end
