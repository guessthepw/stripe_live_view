defmodule LiveViewStripe.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do

    create_stripe_customer_service =
      if Mix.env() == :test,
        do: LiveViewStripe.Billing.CreateStripeCustomer.Stub,
        else: LiveViewStripe.Billing.CreateStripeCustomer

    webhook_processor_service =
      if Mix.env() == :test,
        do: LiveViewStripe.Billing.ProcessWebhook.Stub,
        else: LiveViewStripe.Billing.ProcessWebhook

    children = [
      # Start the Ecto repository
      LiveViewStripe.Repo,
      # Start the Telemetry supervisor
      LiveViewStripeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: LiveViewStripe.PubSub},
      # Start the Endpoint (http/https)
      LiveViewStripeWeb.Endpoint,
      # Start a worker by calling: LiveViewStripe.Worker.start_link(arg)
      # {LiveViewStripe.Worker, arg}
      # Create Stripe Customer servce
      create_stripe_customer_service,
      # Webhook Processor service
      webhook_processor_service
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveViewStripe.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveViewStripeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
