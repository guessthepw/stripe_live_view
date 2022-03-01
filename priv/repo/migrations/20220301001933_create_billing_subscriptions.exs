defmodule LiveViewStripe.Repo.Migrations.CreateBillingSubscriptions do
  use Ecto.Migration

  def change do
    create table(:billing_subscriptions) do
      add :stripe_id, :string
      add :status, :string
      add :current_period_end_at, :naive_datetime
      add :cancel_at, :naive_datetime
      add :plan_id, references(:billing_plans, on_delete: :nothing)
      add :customer_id, references(:billing_customers, on_delete: :nothing)

      timestamps()
    end

    create index(:billing_subscriptions, [:plan_id])
    create index(:billing_subscriptions, [:customer_id])
    create unique_index(:billing_subscriptions, :stripe_id)
  end
end
