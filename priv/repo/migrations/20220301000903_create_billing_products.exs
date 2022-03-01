defmodule LiveViewStripe.Repo.Migrations.CreateBillingProducts do
  use Ecto.Migration

  def change do
    create table(:billing_products) do
      add :stripe_id, :string
      add :stripe_product_name, :string
      timestamps()
    end
    create unique_index(:billing_products, :stripe_id)
  end
end
