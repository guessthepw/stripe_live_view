defmodule LiveViewStripe.Repo.Migrations.CreateBillingPlans do
  use Ecto.Migration

  def change do
    create table(:billing_plans) do
      add :stripe_id, :string
      add :stripe_plan_name, :string
      add :amount, :integer
      add :billing_product_id, references(:billing_products, on_delete: :nothing)

      timestamps()
    end

    create index(:billing_plans, [:billing_product_id])
    create unique_index(:billing_plans, :stripe_id)
  end
end
